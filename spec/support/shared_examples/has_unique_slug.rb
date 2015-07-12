require 'rails_helper'

shared_examples_for 'has_unique_slug' do
  let(:model) { described_class.to_s.underscore.to_sym }

  context 'validation' do
    it 'fails with non-unique slug for language' do
      entity = create model, name: 'Дубль'
      expect(build model, language: entity.language, name: 'Дубль!').not_to be_valid
    end
  end
end
