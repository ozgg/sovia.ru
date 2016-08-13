class BrowsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy, :agents]

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
      render :edit, status: :bad_request
    end
  end

  # delete /browsers/:id
  def destroy
    if @entity.update! deleted: true
      flash[:notice] = t('browsers.destroy.success')
    end
    redirect_to admin_browsers_path
  end

  # get /browsers/:id/agents
  def agents
    @collection = @entity.agents.page_for_administration current_page
  end

  private

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
