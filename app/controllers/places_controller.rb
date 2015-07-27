class PlacesController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @entity = Place.new
  end

  def create
    @entity = Place.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('places.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('places.delete.success')
    end
    redirect_to my_places_path
  end

  protected

  def set_entity
    @entity = Place.find_by! id: params[:id], user: current_user
  end

  def entity_parameters
    params.require(:place).permit(:latitude, :longitude, :azimuth, :name, :image, :description)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity)
  end
end
