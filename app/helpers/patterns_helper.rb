module PatternsHelper
  def link_to_dreambook(pattern)
    link_to pattern.name, dreambook_word_path(letter: pattern.letter, word: pattern.name_for_url)
  end
end
