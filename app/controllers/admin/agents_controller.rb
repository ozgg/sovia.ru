class Admin::AgentsController < ApplicationController
  before_action :restrict_access

  # get /admin/agents
  def index
    @collection = Agent.page_for_administration current_page
  end

  protected

  def restrict_access
    require_role :administrator
  end
end
