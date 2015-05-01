class PlacesController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]
  before_action :restrict_visibility, only: [:show]

  # get /places/new
  def new
    @entity = Place.new
  end

  # post /places
  def create
    @entity = Place.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  # patch /places/:id
  def update
    if @entity.update place_parameters
      redirect_to @entity
    else
      render :edit
    end
  end

  # delete /places/:id
  def destroy
    @entity.destroy
    redirect_to places_path
  end

  protected

  def set_place
    @entity = Place.find params[:id]
  end

  def restrict_editing
    raise UnauthorizedException unless @entity.editable_by? current_user
  end

  def restrict_visibility
    raise UnauthorizedException unless @entity.visible_to? current_user
  end

  def place_parameters
    permitted = [:privacy, :latitude, :longitude, :head_direction, :image, :name, :description]
    params.require(:place).permit permitted
  end

  def creation_parameters
    place_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end
end
