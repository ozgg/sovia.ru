class IndexController < ApplicationController
  def index
    posts = Post.recent(current_user_has_role? :administrator).first(3)
    dreams = Dream.recent.visible_to_user(current_user).first(4)
    questions = Question.recent.first(3)
    @recent = (posts + dreams + questions).sort { |a, b| a.created_at <=> b.created_at }.reverse
  end
end
