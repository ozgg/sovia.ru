class Admin::DreamsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/dreams
  def index
    @collection = Dream.page_for_administration current_page
  end

  # get /admin/dreams/:id
  def show
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Dream.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
