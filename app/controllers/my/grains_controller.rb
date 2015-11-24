class My::GrainsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.grains.order('dream_count desc, slug asc').page(current_page).per(25)
  end
end
