class My::PlacesController < ApplicationController
  before_action :restrict_anonymous_access
  before_action :set_entity, except: [:index]

  # get /my/places
  def index
    @collection = Place.page_for_owner(current_user)
  end

  # get /my/places/:id
  def show
  end

  # get /my/places/:id/dreams
  def dreams

  end

  private

  def set_entity
    @entity = Place.find params[:id]
    raise record_not_found unless @entity.owned_by? current_user
  end
end
