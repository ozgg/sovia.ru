class AdminController < ApplicationController
  before_action :restrict_access

  def index
  end

  private

  def restrict_access
    require_role :administrator
  end
end
