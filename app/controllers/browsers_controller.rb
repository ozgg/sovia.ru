class BrowsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Browser.page_for_administration current_page
  end

  def new
    @entity = Browser.new
  end

  def create
    @entity = Browser.new entity_parameters
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
      redirect_to @entity, notice: t('browsers.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('browsers.delete.success')
    end
    redirect_to browsers_path
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
