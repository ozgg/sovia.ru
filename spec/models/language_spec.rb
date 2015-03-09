require 'rails_helper'

RSpec.describe Language, type: :model do
  describe 'creation' do
    context 'with valid attributes' do
      it 'should be valid' do
        language = build :russian_language
        expect(language).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'should be invalid without code' do
        language = build :language, code: ''
        expect(language).not_to be_valid
      end

      it 'should be invalid without name' do
        language = build :language, name: ''
        expect(language).not_to be_valid
      end

      it 'should be invalid with non-unique code' do
        create :russian_language
        language = build :language, code: 'ru'
        expect(language).not_to be_valid
      end
    end
  end

  describe "guess_from_locale" do
    let!(:language) { create :russian_language }

    it "returns nil for unknown code in locale" do
      I18n.locale = :en
      expect(Language.guess_from_locale).to be_nil
    end

    it "returns language for known code in locale" do
      I18n.locale = :ru
      expect(Language.guess_from_locale).to eq language
    end
  end
end
