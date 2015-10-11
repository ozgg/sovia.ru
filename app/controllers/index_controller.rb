class IndexController < ApplicationController
  def index
    @posts = []
    @dreams = Dream.visible_to_user(current_user).recent.first(3)
  end
end
