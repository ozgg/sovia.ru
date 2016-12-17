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
    @entity = Agent.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted agent #{params[:id]}")
    end
  end
end
