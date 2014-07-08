class My::DeedsController < ApplicationController
  before_action :allow_authorized_only

  def index
    page   = params[:page] || 1
    @deeds = current_user.deeds.order('id desc').page(page).per(20)
  end
end
