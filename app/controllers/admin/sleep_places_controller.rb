# frozen_string_literal: true

# Administrative part of dreams management
class Admin::SleepPlacesController < AdminController
  # get /admin/dreams
  def index
    @collection = SleepPlace.page_for_administration(current_page)
  end

  private

  def component_class
    Biovision::Components::DreamsComponent
  end
end
