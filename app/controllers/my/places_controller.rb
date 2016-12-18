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
    @entity = Place.owned_by(current_user).find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find place #{params[:id]} for #{current_user.id}")
    end
  end
end
