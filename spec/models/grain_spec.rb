require 'rails_helper'

RSpec.describe Grain, type: :model do
  subject { build :grain }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'

  describe 'after initialize' do
    it 'sets uuid' do
      entity = Grain.new
      expect(entity.uuid).not_to be_blank
    end
  end

  describe 'before validation' do
    it 'squishes name' do
      subject.name = ' Слово  и  дело  '
      subject.valid?
      expect(subject.name).to eq('Слово и дело')
    end

    it 'limits name length to 50 letters' do
      subject.name = 'Ы' * 51
      subject.valid?
      expect(subject.name.length).to eq(50)
    end

    it 'generates slug' do
      subject.name = ' Ёжики? В... ту-мане?! '
      subject.valid?
      expect(subject.slug).to eq('ёжикивтумане')
    end
  end

  describe 'validation' do
    it 'fails with non-unique slug for user' do
      create :grain, name: subject.name, user: subject.user
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'passes with non-unique slug for other user' do
      create :grain, name: subject.name
      expect(subject).to be_valid
    end
  end

  describe '::match_by_name' do
    let!(:entity) { create :grain, user: subject.user, name: 'Пример' }

    it 'finds grain by canonized name as slug' do
      expect(Grain.match_by_name subject.user, 'ПРИМЕР').to eq(entity)
    end
  end

  describe '::match_or_create_by_name' do
    context 'when entity does not exist' do
      let(:action) { -> { Grain.match_or_create_by_name subject.user, 'Чудо-метка' } }

      it 'creates new entity' do
        expect(action).to change(subject.class, :count).by(1)
      end

      it 'returns created entity' do
        expect(action.call).to be_an_instance_of(subject.class)
      end

      it 'sets owner of new entity' do
        expect(action.call.user).to eq(subject.user)
      end
    end

    context 'when entity exists' do
      before :each do
        subject.save!
      end

      it 'returns existing entity' do
        expect(Grain.match_or_create_by_name(subject.user, subject.name)).to eq(subject)
      end
    end
  end

  describe '::page_for_owner' do
    let(:user) { create :user }
    let!(:entity) { create :grain, user: user }
    let!(:foreign_entity) { create :grain }

    it 'includes entity' do
      expect(subject.class.page_for_owner(user, 1)).to include(entity)
    end

    it 'does not include foreign entity' do
      expect(subject.class.page_for_owner(user, 1)).not_to include(foreign_entity)
    end
  end
end
