class Admin::IndexController < ApplicationController
  before_action :restrict_access

  # get /admin/
  def index
  end

  protected

  def restrict_access
    require_role :administrator
  end
end
