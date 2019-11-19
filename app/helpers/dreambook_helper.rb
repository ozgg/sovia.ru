# frozen_string_literal: true

# Helper methods for handling dreambook component
module DreambookHelper
  # @param [Pattern] entity
  # @param [String] text
  # @param [Hash] options
  def admin_pattern_link(entity, text = entity.name, options = {})
    link_to(text, admin_pattern_path(id: entity.id), options)
  end

  # @param [Pattern] entity
  # @param [String] text
  # @param [Hash] options
  def pattern_link(entity, text = entity.name, options = {})
    link_to(text, dreambook_word_path(word: text), options)
  end
end
