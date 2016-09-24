require 'rails_helper'

RSpec.describe Place, type: :model do
  subject { build :place }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
  it_behaves_like 'required_name'

  describe 'validation' do
    it 'fails with non-unique name for user' do
      create :place, user: subject.user, name: subject.name
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'passes with the same name for other user' do
      create :place, name: subject.name
      expect(subject).to be_valid
    end
  end

  describe '::page_for_owner' do
    let(:user) { create :user }
    let!(:entity) { create :place, user: user }
    let!(:foreign_entity) { create :place }

    it 'includes entity' do
      expect(subject.class.page_for_owner(user)).to include(entity)
    end

    it 'does not include foreign entity' do
      expect(subject.class.page_for_owner(user)).not_to include(foreign_entity)
    end
  end
end
