# frozen_string_literal: true

# Helper methods for dreams component
module DreamsHelper
  # @param [SleepPlace] entity
  # @param [String] text
  def my_sleep_place_link(entity, text = entity.name)
    link_to(text, my_sleep_place_path(id: entity.id))
  end
end
