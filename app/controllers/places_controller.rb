class PlacesController < ApplicationController
  before_action :restrict_anonymous_access
  before_action :set_entity, except: [:new, :create]
  before_action :check_place_limit, only: [:new, :create]

  # get /places/new
  def new
    @entity = Place.new
  end

  # post /places
  def create
    @entity = Place.new creation_parameters
    if @entity.save
      redirect_to my_place_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /places/:id/edit
  def edit
  end

  # patch /places/:id
  def update
    if @entity.update entity_parameters
      redirect_to my_place_path(@entity), notice: t('places.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /places/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('places.destroy.success')
    end

    redirect_to my_places_path
  end

  private

  def set_entity
    @entity = Place.owned_by(current_user).find_by(id: params[:id])
    if @entity.nil?
      error = "Cannot find place #{params[:id]} owned by #{current_user.id}"
      handle_http_404(error)
    end
  end

  def entity_parameters
    params.require(:place).permit(Place.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity)
  end

  def check_place_limit
    if Place.owned_by(current_user).count >= User::PLACE_LIMIT
      redirect_to my_places_path, alert: t('places.new.maxed_out')
    end
  end
end
