class My::PostsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.posts.order('id desc').page(current_page).per(10)
  end

  def tagged

  end
end
