require 'rails_helper'

RSpec.describe Pattern, type: :model do
  subject { build :pattern }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'required_name'

  describe 'words_string=' do
    before :each do
      subject.save!
    end

    context 'adding new words' do
      let(:action) { -> { subject.words_string = 'первое, ,второе,, первое' } }

      it 'inserts new words into table' do
        expect(action).to change(Word, :count).by(2)
      end

      it 'inserts new distinct links into table' do
        expect(action).to change(PatternWord, :count).by(2)
      end
    end

    context 'changing words list' do
      let!(:old_word) { create :word }
      let!(:new_word) { create :word }
      let(:action) { -> { subject.words_string = new_word.body } }

      before :each do
        create :pattern_word, pattern: subject, word: old_word
      end

      it 'does not change link count' do
        expect(action).not_to change(PatternWord, :count)
      end

      it 'updates existing link' do
        action.call
        expect(subject.words).to eq([new_word])
      end
    end

    context 'passing empty string' do
      let(:action) { -> { subject.words_string = '' } }

      before :each do
        create :pattern_word, pattern: subject
      end

      it 'removes row from pattern_word' do
        expect(action).to change(PatternWord, :count).by(-1)
      end
    end
  end
end
