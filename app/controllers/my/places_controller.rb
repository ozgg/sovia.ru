class My::PlacesController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.places.order('id desc').page(current_page).per(25)
  end
end
