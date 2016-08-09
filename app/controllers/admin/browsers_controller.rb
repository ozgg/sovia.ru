class Admin::BrowsersController < ApplicationController
  before_action :restrict_access

  # get /admin/browsers
  def index
    @collection = Browser.page_for_administration current_page
  end

  protected

  def restrict_access
    require_role :administrator
  end
end
