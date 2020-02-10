# frozen_string_literal: true

# List/show sleep places of current user
class My::SleepPlacesController < ProfileController
  before_action :set_entity, except: :index

  # get /my/sleep_places
  def index
    @collection = SleepPlace.list_for_owner(current_user)
  end

  # get /my/sleep_places/:id
  def show
    @collection = @entity.dreams.page_for_owner(current_user, current_page)
  end

  private

  def set_entity
    @entity = SleepPlace.owned_by(current_user).find_by(id: params[:id])
    handle_http_404('Cannot find sleep place') if @entity.nil?
  end

  def component_class
    Biovision::Components::DreamsComponent
  end
end
