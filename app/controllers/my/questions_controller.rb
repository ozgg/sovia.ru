class My::QuestionsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.questions.order('id desc').page(current_page).per(10)
  end
end
