require 'rails_helper'

RSpec.describe DreamWord, type: :model do
  subject { build :dream_word }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_dream'

  describe 'validation' do
    it 'fails without word' do
      subject.word = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:word)
    end

    it 'fails with non-unique pair' do
      create :dream_word, dream: subject.dream, word: subject.word
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:word_id)
    end
  end
end
