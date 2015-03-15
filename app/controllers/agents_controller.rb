class AgentsController < ApplicationController
  before_action :allow_administrators_only
  before_action :set_agent, except: [:index]

  # get /agents
  def index
    @agents = Agent.order('name asc').page(params[:page] || 1).per(20)
  end

  # get /agents/:id
  def show
  end

  # get /agents/:id/edit
  def edit
  end

  # patch /agents/:id
  def update
    if @agent.update(agent_parameters)
      flash[:notice] = t('agent.updated')
      redirect_to @agent
    else
      render action: :edit
    end
  end

  protected

  def set_agent
    @agent = Agent.find(params[:id])
  end

  def agent_parameters
    params.require(:agent).permit(:is_bot)
  end
end
