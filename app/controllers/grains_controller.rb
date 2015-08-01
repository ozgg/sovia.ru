class GrainsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @entity = Grain.new
  end

  def create
    @entity = Grain.new creation_parameters
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
      redirect_to @entity, notice: t('grains.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('grains.delete.success')
    end
    redirect_to my_grains_path
  end

  protected

  def set_entity
    @entity = Grain.find_by! id: params[:id], user: current_user
  end

  def entity_parameters
    grain = params.require :grain
    parameters = grain.permit(:category, :latitude, :longitude, :image, :name, :description)
    unless grain[:pattern_name].blank?
      parameters[:pattern] = Pattern.match_or_create_by_name grain[:pattern_name], Language.find_by_code(locale)
    end
    parameters
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(language_for_entity)
  end
end
