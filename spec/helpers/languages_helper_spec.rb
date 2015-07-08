require 'rails_helper'

RSpec.describe LanguagesHelper, type: :helper do
  describe 'Getting language name' do
    context 'when name is known' do
      let(:language) { create :russian_language }

      it 'returns localized language name' do
        expect(helper.language_name(language)).to eq('русский')
      end
    end

    context 'when name is unknown' do
      let(:language) { create :language }

      it 'returns language slug' do
        expect(helper.language_name(language)).to eq(language.slug)
      end
    end
  end
end
