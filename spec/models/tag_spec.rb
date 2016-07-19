require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { build :tag }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_name'

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
    it 'fails with non-unique slug' do
      create :tag, name: subject.name
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end

  describe '::match_by_name' do
    let!(:entity) { create :tag, name: 'Пример' }

    it 'finds tag by canonized name as slug' do
      expect(Tag.match_by_name 'ПРИМЕР').to eq(entity)
    end
  end

  describe '::match_or_create_by_name' do
    context 'when tag does not exist' do
      let(:action) { -> { Tag.match_or_create_by_name 'Чудо-метка' } }

      it 'creates new tag' do
        expect(action).to change(Tag, :count).by(1)
      end

      it 'returns created tag' do
        expect(action.call).to be_an_instance_of(Tag)
      end
    end

    context 'when tag exists' do
      before(:each) { subject.save }

      it 'returns existing tag' do
        expect(Tag.match_or_create_by_name(subject.name)).to eq(subject)
      end
    end
  end
end
