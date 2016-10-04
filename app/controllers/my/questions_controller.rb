class My::QuestionsController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/questions
  def index
    @collection = Question.page_for_owner(current_user, current_page)
  end
end
