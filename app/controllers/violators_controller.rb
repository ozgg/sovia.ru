class ViolatorsController < ApplicationController
  before_action :restrict_access

  def index
    @members = Violator.order('id desc').page(current_page).per(25)
  end
  
  protected

  def restrict_access
    demand_role :administrator
  end
end
