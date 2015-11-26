class My::PlacesController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.places.order('name asc')
  end
end
