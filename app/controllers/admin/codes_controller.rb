class Admin::CodesController < ApplicationController
  before_action :restrict_access

  # get /admin/codes
  def index
    @collection = Code.page_for_administration current_page
  end

  protected

  def restrict_access
    require_role :administrator
  end
end
