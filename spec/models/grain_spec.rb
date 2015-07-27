require 'rails_helper'

RSpec.describe Grain, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'required_user'
  it_behaves_like 'has_name_with_slug'
  it_behaves_like 'has_owner'

  describe 'validation' do
    it 'fails with non-unique slug for user and language' do
      grain = create :grain, name: 'Дубль'
      expect(build :grain, language: grain.language, user: grain.user, name: 'Дубль!').not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :grain).to be_valid
    end
  end

  describe '#match_by_name' do
    let!(:grain) { create :grain, name: 'Пример' }

    it 'finds grain by canonized name as slug' do
      expect(Grain.match_by_name 'ПРИМЕР', grain.language, grain.user).to eq(grain)
    end
  end

  describe '#match_or_create_by_name' do
    let(:user) { create :user }
    let(:language) { create :language }
    let(:grain) { create :grain, language: language, user: user }

    context 'when grain does not exist' do
      let(:action) { -> { Grain.match_or_create_by_name 'Чудо-метка', language, user } }

      it 'creates new grain' do
        expect(action).to change(Grain, :count).by(1)
      end

      it 'returns created grain' do
        expect(action.call).to be_a(Grain)
      end
    end

    context 'when grain exists' do
      it 'returns grain' do
        expect(Grain.match_or_create_by_name grain.name, language, user).to eq(grain)
      end
    end
  end
end
