class My::PostsController < ApplicationController
  before_action :allow_authorized_only

  # get /my/posts
  def index
    @posts = Post.where(user: current_user).order('id desc').page(current_page).per(5)
  end
end
