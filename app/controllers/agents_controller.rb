class AgentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Agent.page_for_administrator current_page
  end

  def new
    @entity = Agent.new
  end

  def create
    @entity = Agent.new entity_parameters
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
      redirect_to @entity, notice: t('agents.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('agents.delete.success')
    end
    redirect_to agents_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Agent.find params[:id]
  end

  def entity_parameters
    params.require(:agent).permit(:browser_id, :name, :mobile, :bot)
  end
end
