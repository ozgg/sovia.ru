require 'rails_helper'

RSpec.describe UserLanguage, type: :model do
  context 'when validating' do
    it 'is invalid without user' do
      user_language = build :user_language, user: nil
      expect(user_language).not_to be_valid
    end

    it 'is invalid without language' do
      user_language = build :user_language, language: nil
      expect(user_language).not_to be_valid
    end

    it 'is valid with valid attributes' do
      user_language = build :user_language
      expect(user_language).to be_valid
    end

    it 'has unique pair user-language' do
      existing_pair = create :user_language
      user_language = build :user_language, user: existing_pair.user, language: existing_pair.language
      expect(user_language).not_to be_valid
    end
  end
end
