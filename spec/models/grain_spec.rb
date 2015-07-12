require 'rails_helper'

RSpec.describe Grain, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'required_user'
  it_behaves_like 'has_name_with_slug'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Grain.included_modules).to include(HasOwner)
    end
  end

  describe 'validation' do
    it 'fails with non-unique slug for user and language' do
      grain = create :grain, name: 'Дубль'
      expect(build :grain, language: grain.language, user: grain.user, name: 'Дубль!').not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :grain).to be_valid
    end
  end
end
