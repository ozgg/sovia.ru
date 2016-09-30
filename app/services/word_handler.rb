class WordHandler
  attr_reader :parts, :word_ids

  EXCLUSION_PATTERN = /[^-a-zA-Z0-9а-яёА-ЯЁ]/

  def initialize(string, create_words)
    @parts = string.gsub(EXCLUSION_PATTERN, ' ').split(/\s+/).uniq
    prepare_word_ids(create_words)
  end

  def pattern_ids
    PatternWord.where(word_id: @word_ids).pluck(:pattern_id)
  end

  private

  # @param [Boolean] create_words
  def prepare_word_ids(create_words)
    @word_ids = []
    @parts.reject { |part| part.blank? }.map do |part|
      word = Word.find_by('body ilike ?', part)
      if word.nil?
        @word_ids << Word.create(body: part).id if create_words
      else
        @word_ids << word.id
      end
    end
    @word_ids.uniq!
  end
end
