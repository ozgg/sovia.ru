require 'rails_helper'

RSpec.describe PatternsHelper, type: :helper do
  describe '#link_to_dreambook' do
    it 'returns link to word in dreambook' do
      pattern = create :pattern
      expected = link_to pattern.name, dreambook_word_path(letter: pattern.letter, word: pattern.name)
      expect(helper.link_to_dreambook(pattern)).to eq(expected)
    end
  end
end
