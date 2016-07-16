class Admin::UsersController < ApplicationController
  before_action :restrict_access

  # get /admin/users
  def index
    @filter     = params[:filter] || Hash.new
    @collection = User.page_for_administration current_page, @filter
  end

  protected

  def restrict_access
    require_role :administrator
  end
end
