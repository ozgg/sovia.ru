class DeedsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @entity = Deed.new
  end

  def create
    @entity = Deed.new creation_parameters
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
      redirect_to @entity, notice: t('deeds.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('deeds.delete.success')
    end
    redirect_to my_deeds_path
  end

  protected

  def set_entity
    @entity = Deed.find_by! id: params[:id], user: current_user
  end

  def entity_parameters
    params.require(:deed).permit(:goal_id, :essence)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity)
  end
end
