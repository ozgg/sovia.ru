# frozen_string_literal: true

User.class_eval do
  after_create :add_free_interpretations

  private

  def add_free_interpretations
    handler = Biovision::Components::DreamsComponent[self]
    handler.request_count = handler.settings['free_interpretations'].to_i
  end
end
