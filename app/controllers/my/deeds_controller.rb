class My::DeedsController < ApplicationController
  before_action :allow_authorized_only

  def index
    @deeds = current_user.deeds.order('id desc').page(current_page).per(20)
  end
end
