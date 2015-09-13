require 'rails_helper'

RSpec.describe Dream, type: :model do
  it_behaves_like 'has_azimuth'
  it_behaves_like 'has_owner'
  it_behaves_like 'has_trace'

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :dream).to be_valid
    end

    it 'fails without body' do
      dream = build :dream, body: ' '
      expect(dream).not_to be_valid
    end

    it 'fails with mood lower than -2' do
      expect(build :dream, mood: -3).not_to be_valid
    end

    it 'fails with mood greater than 2' do
      expect(build :dream, mood: 3).not_to be_valid
    end

    it 'fails with lucidity less than 0' do
      expect(build :dream, lucidity: -1).not_to be_valid
    end

    it 'fails with lucidity greater than 5' do
      expect(build :dream, lucidity: 6).not_to be_valid
    end

    it 'fails with time of day less than 0' do
      expect(build :dream, time_of_day: -1).not_to be_valid
    end

    it 'fails with time of day greater than 23' do
      expect(build :dream, time_of_day: 24).not_to be_valid
    end

    it 'fails with foreign place' do
      user  = create :user
      place = create :place
      expect(build :dream, user: user, place: place).not_to be_valid
    end

    it 'fails with invalid privacy' do
      expect(build :dream, privacy: Dream.privacies[:visible_to_community]).not_to be_valid
    end
  end

  describe '#visible_to?' do
    shared_examples 'visible_to_anonymous' do
      it 'returns true for anonymous user' do
        expect(dream).to be_visible_to(nil)
      end
    end

    shared_examples 'invisible_to_anonymous' do
      it 'returns false for anonymous user' do
        expect(dream).not_to be_visible_to(nil)
      end
    end

    shared_examples 'visible_to_other_user' do
      it 'returns true other user' do
        user = create :user
        expect(dream).to be_visible_to(user)
      end
    end

    shared_examples 'invisible_to_other_user' do
      it 'returns false for other user' do
        user = create :user
        expect(dream).not_to be_visible_to(user)
      end
    end

    shared_examples 'visible_to_followees' do
      it 'returns true for followee' do
        followee = create :user
        allow(dream.user).to receive(:follows?).with(followee).and_return(true)
        expect(dream).to be_visible_to(followee)
      end
    end

    shared_examples 'invisible_to_followees' do
      it 'returns true for followee' do
        followee = create :user
        allow(dream.user).to receive(:follows?).with(followee).and_return(false)
        expect(dream).not_to be_visible_to(followee)
      end
    end

    shared_examples 'visible_to_owner' do
      it 'returns true for owner' do
        expect(dream).to be_visible_to(dream.user)
      end
    end

    context 'when dream is generally accessible' do
      let!(:dream) { create :owned_dream }

      it_behaves_like 'visible_to_anonymous'
      it_behaves_like 'visible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when dream is visible to community' do
      let!(:dream) { create :dream_for_community }

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'visible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when dream is visible to followees' do
      let!(:dream) { create :dream_for_followees }

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'invisible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when dream is personal' do
      let!(:dream) { create :personal_dream }

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'invisible_to_other_user'
      it_behaves_like 'invisible_to_followees'
      it_behaves_like 'visible_to_owner'
    end
  end

  describe '#grains_string=' do
    let!(:dream) { create :owned_dream }
    let!(:existing_pattern) { create :pattern }
    let!(:existing_grain) { create :grain, pattern: existing_pattern }

    context 'in common case' do
      it 'adds new non-empty and non-repeating grains to dream' do
        expect { dream.grains_string = 'a,,A,c,c,b,' }.to change(DreamGrain, :count).by(3)
      end

      it 'adds new non-empty and non-repeating patterns to dream' do
        expect { dream.grains_string = 'a,,A,c,c,b,' }.to change(DreamPattern, :count).by(3)
      end

      it 'removes absent patterns' do
        create :dream_pattern, dream: dream, pattern: existing_pattern
        expect { dream.grains_string = ''}.to change(DreamPattern, :count).by(-1)
      end

      it 'removes absent grains' do
        create :dream_grain, dream: dream, grain: existing_grain
        expect { dream.grains_string = ''}.to change(DreamGrain, :count).by(-1)
      end
    end

    context 'when grain has custom pattern link' do
      it 'links grain with pattern in parenthesis' do
        pattern = create :pattern
        dream.grains_string = "#{existing_grain.name} (#{pattern.name})"
        existing_grain.reload
        expect(dream.patterns).to eq([pattern])
      end

      it 'removes link for empty parenthesis' do
        dream.grains_string = "#{existing_grain} ()"
        existing_grain.reload
        expect(dream.patterns).to be_blank
      end

      it 'removes link for grain in parenthesis' do
        dream.grains_string = "(#{existing_grain})"
        existing_grain.reload
        expect(dream.patterns).to be_blank
      end
    end
  end

  describe '#cache_patterns!' do
    let!(:dream) { create :owned_dream }

    it 'adds patterns by user to patterns_cache' do
      link = create :dream_pattern, dream: dream
      dream.cache_patterns!
      expect(dream.patterns_cache).to include(link.pattern.name)
    end

    it 'adds suggested patterns to patterns_cache' do
      link = create :suggested_dream_pattern, dream: dream
      dream.cache_patterns!
      expect(dream.patterns_cache).to include(link.pattern.name)
    end

    it 'adds forced patterns to patterns_cache' do
      link = create :forced_dream_pattern, dream: dream
      dream.cache_patterns!
      expect(dream.patterns_cache).to include(link.pattern.name)
    end

    it 'does not add rejected patterns to patterns_cache' do
      link = create :rejected_dream_pattern, dream: dream
      dream.cache_patterns!
      expect(dream.patterns_cache).not_to include(link.pattern.name)
    end
  end
end
