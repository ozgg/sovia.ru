class QuestionsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index, :show]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /questions
  def index
    @collection = Question.page_for_visitors(current_page)
  end

  # get /questions/new
  def new
    @entity = Question.new
  end

  # post /questions
  def create
    @entity = Question.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new, status: :bad_request
    end
  end

  # get /questions/:id
  def show
    set_adjacent_entities
  end

  # get /questions/:id/edit
  def edit
  end

  # patch /questions/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('questions.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /questions/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('questions.destroy.success')
    end

    redirect_to questions_path
  end

  private

  def set_entity
    @entity = Question.find params[:id]
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by? current_user
  end

  def creation_parameters
    question_parameters = params.require(:question).permit(Question.entity_parameters)
    question_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def entity_parameters
    params.require(:question).permit(Question.entity_parameters)
  end

  def set_adjacent_entities
    @adjacent = {
        prev: Question.where('id < ?', @entity.id).order('id desc').first,
        next: Question.where('id > ?', @entity.id).order('id asc').first
    }
  end
end
