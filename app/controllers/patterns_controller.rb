class PatternsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Pattern.order('slug asc').page(current_page).per(25)
  end

  def new
    @entity = Pattern.new
  end

  def create
    @entity = Pattern.new creation_parameters
    if @entity.save
      set_links
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
      set_links
      redirect_to @entity, notice: t('patterns.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('patterns.delete.success')
    end
    redirect_to patterns_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Pattern.find params[:id]
  end

  def entity_parameters
    params.require(:pattern).permit(:name, :image, :description)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def set_links
    @entity.links = params[:links].nil? ? Hash.new : params[:links]
  end
end
