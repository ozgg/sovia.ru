# frozen_string_literal: true

# List/show dreams of current user
class My::DreamsController < ProfileController
  before_action :set_entity, except: :index

  # get /my/dreams
  def index
    @collection = Dream.page_for_owner(current_user, current_page)
  end

  # get /my/dreams/:id
  def show
  end

  private

  def set_entity
    @entity = Dream.owned_by(current_user).find_by(id: params[:id])
    handle_http_404('Cannot find dream') if @entity.nil?
  end

  def component_slug
    Biovision::Components::DreamsComponent::SLUG
  end
end
