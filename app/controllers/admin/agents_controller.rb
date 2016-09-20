class Admin::AgentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/agents
  def index
    @filter     = params[:filter] || Hash.new
    @collection = Agent.page_for_administration current_page, @filter
  end

  # get /admin/agents/:id
  def show
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Agent.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
