# frozen_string_literal: true

# Administrative part of dreams management
class Admin::DreamsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/dreams
  def index
    @collection = Dream.page_for_administration(current_page)
  end

  # get /admin/dreams/:id
  def show
  end

  private

  def restrict_access
    component_restriction Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = Dream.find_by(id: params[:id])
    handle_http_404('Cannot find dream') if @entity.nil?
  end

  def set_handler
    slug = Biovision::Components::DreamsComponent::SLUG

    @handler = Biovision::Components::BaseComponent.handler(slug, current_user)
  end
end
