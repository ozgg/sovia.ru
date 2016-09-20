class Admin::CodesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/codes
  def index
    @collection = Code.page_for_administration current_page
  end

  # get /admin/codes/:id
  def show
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Code.find params[:id]
  end
end
