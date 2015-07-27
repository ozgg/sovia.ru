class My::DeedsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.deeds.order('id desc').page(current_page).per(25)
  end
end
