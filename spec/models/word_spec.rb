require 'rails_helper'

RSpec.describe Word, type: :model do
  subject { build :word }

  it_behaves_like 'has_valid_factory'

  describe 'before validation' do
    it 'downcases body' do
      subject.body = 'СЛОВО'
      subject.valid?
      expect(subject.body).to eq('слово')
    end
  end

  describe 'validation' do
    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with non-unique body' do
      create :word, body: subject.body
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with too long body' do
      subject.body = 'ы' * 51
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end
  end

  describe 'patterns_string=' do
    before :each do
      subject.save!
    end

    context 'adding new patterns' do
      let(:action) { -> { subject.patterns_string = 'первое, ,второе,, первое' } }

      it 'inserts new patterns into table' do
        expect(action).to change(Pattern, :count).by(2)
      end

      it 'inserts new distinct links into table' do
        expect(action).to change(PatternWord, :count).by(2)
      end
    end

    context 'changing patterns list' do
      let!(:old_pattern) { create :pattern }
      let!(:new_pattern) { create :pattern }
      let(:action) { -> { subject.patterns_string = new_pattern.name } }

      before :each do
        create :pattern_word, pattern: old_pattern, word: subject
      end

      it 'does not change link count' do
        expect(action).not_to change(PatternWord, :count)
      end

      it 'updates existing link' do
        action.call
        expect(subject.patterns).to eq([new_pattern])
      end
    end

    context 'passing empty string' do
      let(:action) { -> { subject.patterns_string = '' } }

      before :each do
        create :pattern_word, word: subject
      end

      it 'removes row from pattern_word' do
        expect(action).to change(PatternWord, :count).by(-1)
      end
    end
  end
end
