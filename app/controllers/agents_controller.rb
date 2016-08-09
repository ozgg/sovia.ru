class AgentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  # get /agents/new
  def new
    @entity = Agent.new
  end

  # post /agents
  def create
    @entity = Agent.new entity_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  # get /agents/:id
  def show
  end

  # get /agents/:id/edit
  def edit
  end

  # patch /agents/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('agents.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /agents/:id
  def destroy
    if @entity.update! deleted: true
      flash[:notice] = t('agents.destroy.success')
    end
    redirect_to admin_agents_path
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Agent.find params[:id]
  end

  def entity_parameters
    params.require(:agent).permit(Agent.entity_parameters)
  end
end
