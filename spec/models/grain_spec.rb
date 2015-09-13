require 'rails_helper'

RSpec.describe Grain, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_name_with_slug'
  it_behaves_like 'has_owner'

  describe 'validation' do
    it 'fails with non-unique slug for user' do
      grain = create :grain, name: 'Дубль'
      expect(build :grain, user: grain.user, name: 'Дубль!').not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :grain).to be_valid
    end
  end

  describe '#match_by_name' do
    let!(:grain) { create :grain, name: 'Пример' }

    it 'finds grain by canonized name as slug' do
      expect(Grain.match_by_name 'ПРИМЕР', grain.user).to eq(grain)
    end
  end

  describe '#match_or_create_by_name' do
    let(:user) { create :user }
    let(:grain) { create :grain, user: user }

    context 'when grain does not exist' do
      let(:action) { -> { Grain.match_or_create_by_name 'Чудо-метка', user } }

      it 'creates new grain' do
        expect(action).to change(Grain, :count).by(1)
      end

      it 'returns created grain' do
        expect(action.call).to be_a(Grain)
      end
    end

    context 'when grain exists' do
      it 'returns grain' do
        expect(Grain.match_or_create_by_name grain.name, user).to eq(grain)
      end
    end
  end

  describe '#extract_names' do
    context 'when long name has no parenthesis' do
      it 'returns original name twice' do
        long_name = 'simple case'
        expect(Grain.extract_names long_name).to eq([long_name, long_name])
      end
    end

    context 'when long name has pattern in parenthesis' do
      it 'returns grain name and pattern name' do
        grain_name = 'kitty'
        pattern_name = 'pussy'
        expect(Grain.extract_names " #{grain_name} ( #{pattern_name} )").to eq([grain_name, pattern_name])
      end
    end

    context 'when long name has empty parenthesis' do
      it 'returns grain name and nil' do
        expect(Grain.extract_names 'kitty ( )').to eq(['kitty', nil])
      end
    end

    context 'when long name has only grain in parenthesis' do
      it 'returns grain name and nil' do
        expect(Grain.extract_names '( kitty )').to eq(['kitty', nil])
      end
    end
  end
end
