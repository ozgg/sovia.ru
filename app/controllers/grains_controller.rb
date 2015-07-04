class GrainsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  # get /grains
  def index
    @entities = Grain.where(user: current_user).order('code asc').page(current_page).per(25)
  end

  def new
    @entity = Grain.new
  end

  def create
    @entity = Grain.new creation_parameters
    if @entity.save
      flash[:notice] = t('grains.create.created')
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

  end

  def destroy
    @entity.destroy
    redirect_to grains_path
  end

  protected

  def set_entity
    @entity = Grain.find params[:id]
    raise record_not_found unless @entity.owned_by? current_user
  end

  def grain_parameters
    permitted = [:name, :body, :image, :category, :latitude, :longitude]
    params.require(:grain).permit(permitted)
  end

  def creation_parameters
    grain_parameters.merge(owner_for_entity).merge(language_for_entity)
  end
end
