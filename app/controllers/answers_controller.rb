class AnswersController < ApplicationController
  before_action :allow_authorized_only

  def index
    demand_role :moderator
  end

  def new
  end

  def create
    @answer = Answer.new(creation_parameters)
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  protected

  def answer_parameters
    params.require(:answer).permit(:question_id, :body)
  end

  def creation_parameters
    answer_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end
end
