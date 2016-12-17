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
    @entity = Browser.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted browser #{params[:id]}")
    end
  end
end
