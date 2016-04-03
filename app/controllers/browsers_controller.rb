class BrowsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy, :toggle]

  # get /browsers
  def index
    @collection = Browser.page_for_administration current_page
  end

  # get /browsers/new
  def new
    @entity = Browser.new
  end

  # post /browsers
  def create
    @entity = Browser.new entity_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  # get /browsers/:id
  def show
  end

  # get /browsers/:id/edit
  def edit
  end

  # patch /browsers/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('browsers.update.success')
    else
      render :edit
    end
  end

  # delete /browsers/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('browsers.delete.success')
    end
    redirect_to browsers_path
  end

  # post /browsers/:id/toggle
  def toggle
    render json: @entity.toggle_parameter(params[:parameter].to_s)
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Browser.find params[:id]
  end

  def entity_parameters
    params.require(:browser).permit(Browser.entity_parameters)
  end
end
