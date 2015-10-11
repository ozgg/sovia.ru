class IndexController < ApplicationController
  def index
    @posts = Post.recent_posts(current_user_has_role? :administrator)
    @dreams = Dream.recent_dreams(current_user)
  end
end
