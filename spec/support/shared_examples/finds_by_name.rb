require 'rails_helper'

shared_examples_for 'finds_by_name' do
  let(:model) { described_class.to_s.underscore.to_sym }

  describe '#match_by_name' do
    let!(:entity) { create model, name: 'Пример' }

    it 'finds entity by canonized name as slug' do
      expect(described_class.match_by_name 'ПРИМЕР', entity.language).to eq(entity)
    end
  end

  describe '#match_or_create_by_name' do
    let(:language) { create :language }
    let(:entity) { create model, language: language }

    context 'when entity does not exist' do
      let(:action) { -> { described_class.match_or_create_by_name 'Чудо-метка', language } }

      it 'creates new entity' do
        expect(action).to change(described_class, :count).by(1)
      end

      it 'returns created entity' do
        expect(action.call).to be_a(described_class)
      end
    end

    context 'when entity exists' do
      it 'returns entity' do
        expect(described_class.match_or_create_by_name entity.name, language).to eq(entity)
      end
    end
  end
end
