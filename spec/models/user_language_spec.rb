require 'rails_helper'

RSpec.describe UserLanguage, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :user_language).to be_valid
    end

    it 'fails with non-unique pair' do
      pair = create :user_language
      expect(build :user_language, user: pair.user, language: pair.language).not_to be_valid
    end
  end
end
