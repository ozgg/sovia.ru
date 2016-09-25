require 'rails_helper'

RSpec.describe Dream, type: :model do
  subject { build :dream }

  let!(:generally_accessible_dream) { create :dream }
  let!(:dream_for_community) { create :dream_for_community }
  let!(:dream_for_followees) { create :dream_for_followees }
  let!(:personal_dream) { create :personal_dream }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_body'

  describe 'after initialize' do
    it 'sets uuid' do
      entity = Grain.new
      expect(entity.uuid).not_to be_blank
    end
  end

  describe 'vefore validation' do
    it 'converts empty title to nil slug' do
      subject.valid?
      expect(subject.slug).to be_nil
    end

    it 'normalizes non-empty title' do
      subject.title = ' Сон  в  тестах! '
      subject.valid?
      expect(subject.slug).to eq('son-v-testakh')
    end
  end

  describe 'validation' do
    it 'fails without privacy' do
      subject.privacy = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privacy)
    end

    it 'fails for foreign place' do
      subject.user  = create :user
      subject.place = create :place
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:place_id)
    end

    it 'fails for non-generally accessible anonymous dream' do
      subject.privacy = Dream.privacies[:visible_to_community]
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privacy)
    end

    it 'fails with mood lower than -2' do
      subject.mood = -3
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:mood)
    end

    it 'fails with mood greater than 2' do
      subject.mood = 3
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:mood)
    end

    it 'fails with lucidity less than 0' do
      subject.lucidity = -1
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:lucidity)
    end

    it 'fails with lucidity greater than 5' do
      subject.lucidity = 6
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:lucidity)
    end
  end

  describe '#visible_to?' do
    before :each do
      subject.user = create :user
    end
    
    shared_examples 'visible_to_anonymous' do
      it 'returns true for anonymous user' do
        expect(subject).to be_visible_to(nil)
      end
    end

    shared_examples 'invisible_to_anonymous' do
      it 'returns false for anonymous user' do
        expect(subject).not_to be_visible_to(nil)
      end
    end

    shared_examples 'visible_to_other_user' do
      it 'returns true other user' do
        user = create :user
        expect(subject).to be_visible_to(user)
      end
    end

    shared_examples 'invisible_to_other_user' do
      it 'returns false for other user' do
        user = create :user
        expect(subject).not_to be_visible_to(user)
      end
    end

    shared_examples 'visible_to_followees' do
      it 'returns true for followee' do
        followee = create :user
        allow(subject.user).to receive(:follows?).with(followee).and_return(true)
        expect(subject).to be_visible_to(followee)
      end
    end

    shared_examples 'invisible_to_followees' do
      it 'returns true for followee' do
        followee = create :user
        allow(subject.user).to receive(:follows?).with(followee).and_return(false)
        expect(subject).not_to be_visible_to(followee)
      end
    end

    shared_examples 'visible_to_owner' do
      it 'returns true for owner' do
        expect(subject).to be_visible_to(subject.user)
      end
    end

    context 'when dream is generally accessible' do
      it_behaves_like 'visible_to_anonymous'
      it_behaves_like 'visible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when dream is visible to community' do
      before :each do
        subject.privacy = Dream.privacies[:visible_to_community]
      end

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'visible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when dream is visible to followees' do
      before :each do
        subject.privacy = Dream.privacies[:visible_to_followees]
      end

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'invisible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when dream is personal' do
      before :each do
        subject.privacy = Dream.privacies[:personal]
      end

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'invisible_to_other_user'
      it_behaves_like 'invisible_to_followees'
      it_behaves_like 'visible_to_owner'
    end
  end

  describe '::page_for_administration' do
    let!(:result) { Dream.page_for_administration(1) }

    it 'includes generally accessible dreams' do
      expect(result).to include(generally_accessible_dream)
    end

    it 'includes dreams for community' do
      expect(result).to include(dream_for_community)
    end

    it 'does not include dreams for followees' do
      expect(result).not_to include(dream_for_followees)
    end

    it 'does not include personal dreams' do
      expect(result).not_to include(personal_dream)
    end
  end

  describe '::page_for_visitors' do
    context 'when user is anonymous' do
      let!(:result) { Dream.page_for_visitors(nil, 1) }

      it 'includes generally accessible dreams' do
        expect(result).to include(generally_accessible_dream)
      end

      it 'does not include dreams for community' do
        expect(result).not_to include(dream_for_community)
      end

      it 'does not include dreams for followees' do
        expect(result).not_to include(dream_for_followees)
      end

      it 'does not include personal dreams' do
        expect(result).not_to include(personal_dream)
      end
    end

    context 'when user is not anonymous' do
      let!(:result) { Dream.page_for_visitors(create(:user), 1) }

      it 'includes generally accessible dreams' do
        expect(result).to include(generally_accessible_dream)
      end

      it 'includes dreams for community' do
        expect(result).to include(dream_for_community)
      end

      it 'does not include dreams for followees' do
        expect(result).not_to include(dream_for_followees)
      end

      it 'does not include personal dreams' do
        expect(result).not_to include(personal_dream)
      end
    end
  end

  describe '::page_for_owner' do
    let!(:result) { Dream.page_for_owner(personal_dream.user, 1) }

    it 'includes owned dream' do
      expect(result).to include(personal_dream)
    end

    it 'does not include foreign dream' do
      expect(result).not_to include(generally_accessible_dream)
    end
  end
end
