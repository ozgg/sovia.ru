require 'rails_helper'

RSpec.describe Language, type: :model do
  context 'validating' do
    it 'fails with empty code' do
      language = build :language, code: ' '
      expect(language).not_to be_valid
    end

    it 'fails with empty slug' do
      language = build :language, slug: ' '
      expect(language).not_to be_valid
    end

    it 'fails with non-unique code' do
      create :russian_language
      language = build :language, code: 'ru'
      expect(language).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :language).to be_valid
    end
  end
end
