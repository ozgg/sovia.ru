class AnswersController < ApplicationController
  before_action :allow_authorized_only

  def index
    demand_role :moderator
  end

  def new
  end

  def create
    render :new
  end

  protected

  def answer_parameters
    params.require(:answer).permit(:question_id, :body)
  end
end
