require 'rails_helper'

RSpec.describe PatternWord, type: :model do
  subject { build :pattern_word }

  it_behaves_like 'has_valid_factory'

  describe 'validation' do
    it 'fails without pattern' do
      subject.pattern = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:pattern)
    end

    it 'fails without word' do
      subject.word = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:word)
    end

    it 'fails with non-unique pair' do
      create :pattern_word, pattern: subject.pattern, word: subject.word
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:word_id)
    end
  end
end
