class My::DeedsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = Deed.page_for_user current_page, current_user
  end
end
