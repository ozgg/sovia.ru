require 'rails_helper'

RSpec.describe Dream, type: :model do
  it_behaves_like 'has_language'
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

  describe '#visible_to?', wip: true do
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
end
