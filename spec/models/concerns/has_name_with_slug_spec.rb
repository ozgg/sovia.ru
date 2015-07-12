require 'rails_helper'

shared_examples_for 'has_name_with_slug' do
  let(:model) { described_class.to_s.underscore.to_sym }

  context 'validation' do
    it 'fails without name' do
      entity = build model, name: ' '
      expect(entity).not_to be_valid
    end

    it 'squishes name' do
      entity = build model, name: ' Слово  и  дело  '
      entity.valid?
      expect(entity.name).to eq('Слово и дело')
    end

    it 'limits name length to 50 letters' do
      entity = build model, name: 'Ы' * 51
      entity.valid?
      expect(entity.name.length).to eq(50)
    end

    it 'generates slug' do
      entity = build model, name: ' Ёжики? В... ту-мане?! '
      entity.valid?
      expect(entity.slug).to eq('ёжикивтумане')
    end
  end
end
