class AnalyzeDreamJob < ApplicationJob
  queue_as :default

  # @param [Integer] dream_id
  def perform(dream_id)
    dream = Dream.find_by(id: dream_id)
    if dream.is_a?(Dream)
      string  = dream.body.gsub(Dream::NAME_PATTERN, '').gsub(Dream::LINK_PATTERN, '')
      handler = WordHandler.new(string, true)

      dream.word_ids    = handler.word_ids
      dream.pattern_ids = dream.pattern_ids | handler.pattern_ids
    end
  end
end
