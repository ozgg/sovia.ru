class QuestionsController < ApplicationController
  before_action :allow_authorized_only, only: [:create]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # get /questions
  def index
    @questions = Question.suitable_for(current_user).order('id desc').page(current_page).per(10)
  end

  # get /questions/new
  def new
    @question = Question.new
  end

  # post /questions
  def create
    @question = Question.new(creation_parameters)
    if @question.save
      flash[:notice] = t('question.created')
      redirect_to @question
    else
      render :new
    end
  end

  # get /questions/:id/edit
  def edit
    demand_role :moderator
  end

  # patch /questions/:id
  def update
    demand_role :moderator

    if @question.update question_parameters
      flash[:notice] = t('question.updated')
      redirect_to @question
    else
      render :edit
    end
  end

  # delete /questions/:id
  def destroy
    demand_role :moderator

    if @question.destroy
      flash[:notice] = t('question.deleted')
    end
    redirect_to questions_path
  end

  protected

  def question_parameters
    params.require(:question).permit(:body)
  end

  def creation_parameters
    question_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
