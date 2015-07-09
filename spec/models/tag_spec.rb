require 'rails_helper'

RSpec.describe Tag, type: :model do
  context 'validating' do
    it 'fails without name' do
      tag = build :tag, name: ' '
      expect(tag).not_to be_valid
    end

    it 'normalizes name before validation' do
      tag = build :tag, name: ' Слово  и  дело  '
      tag.valid?
      expect(tag.name).to eq('Слово и дело')
    end

    it 'generates slug before validation' do
      tag = build :tag, name: ' Ёжики? В тумане?! '
      tag.valid?
      expect(tag.slug).to eq('ёжикивтумане')
    end

    it 'fails with non-unique slug for language' do
      tag = create :tag, name: 'Дубль'
      expect(build :tag, language: tag.language, name: 'Дубль!').not_to be_valid
    end
  end
end
