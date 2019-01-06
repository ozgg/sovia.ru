# frozen_string_literal: true

# Helper methods for dreambook component
module DreambookHelper
  # @param [DreambookEntry] entity
  # @param [String] text
  def admin_dreambook_entry_link(entity, text = entity.name)
    link_to(text, admin_dreambook_entry_path(id: entity.id))
  end

  # @param [Pattern] entity
  # @param [String] text
  def admin_pattern_link(entity, text = entity.name)
    link_to(text, admin_pattern_path(id: entity.id))
  end
end
