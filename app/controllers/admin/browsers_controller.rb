class Admin::BrowsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/browsers
  def index
    @collection = Browser.page_for_administration current_page
  end

  # get /admin/browsers/:id
  def show
  end

  # get /admin/browsers/:id/agents
  def agents
    @collection = @entity.agents.page_for_administration current_page
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Browser.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
