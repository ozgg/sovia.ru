# frozen_string_literal: true

# Administrative part of dream patterns management
class Admin::DreambookQueriesController < AdminController
  # get /admin/dreambook_queries
  def index
    @collection = DreambookQuery.page_for_administration(current_page)
  end

  private

  def component_slug
    Biovision::Components::DreambookComponent::SLUG
  end
end
