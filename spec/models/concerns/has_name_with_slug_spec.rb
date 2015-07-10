require 'rails_helper'

shared_examples_for 'has_name_with_slug' do
  let(:model) { described_class.to_s.underscore.to_sym }

  context 'validation' do
    it 'fails without name' do
      entity = build model, name: ' '
      expect(entity).not_to be_valid
    end

    it 'normalizes name before validation' do
      entity = build model, name: ' Слово  и  дело  '
      entity.valid?
      expect(entity.name).to eq('Слово и дело')
    end

    it 'generates slug before validation' do
      entity = build model, name: ' Ёжики? В... ту-мане?! '
      entity.valid?
      expect(entity.slug).to eq('ёжикивтумане')
    end

    it 'fails with non-unique slug for language' do
      entity = create model, name: 'Дубль'
      expect(build :tag, language: entity.language, name: 'Дубль!').not_to be_valid
    end
  end
end
