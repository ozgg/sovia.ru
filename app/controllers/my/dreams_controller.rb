class My::DreamsController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/dreams
  def index
    @collection = Dream.page_for_owner(current_user, current_page)
  end
end
