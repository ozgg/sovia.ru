class PostsController < ApplicationController

  # get /posts
  def index
    page = params[:page] || 1
    @posts = Post.posts.order('id desc').page(page).per(5)
  end
end
