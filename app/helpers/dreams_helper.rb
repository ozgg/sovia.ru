# frozen_string_literal: true

# Helper methods for dreams component
module DreamsHelper
  # @param [SleepPlace] entity
  # @param [String] text
  def my_sleep_place_link(entity, text = entity.name)
    link_to(text, my_sleep_place_path(id: entity.id))
  end

  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def my_dream_link(entity, text = entity.title, options = {})
    link_to(text || t(:untitled), my_dream_path(id: entity.id), options)
  end

  # @param [Dream] entity
  def dream_privacy(entity)
    t("activerecord.attributes.dream.privacies.#{entity.privacy}")
  end
end
