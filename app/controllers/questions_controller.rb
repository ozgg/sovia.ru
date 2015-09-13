class QuestionsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index, :new, :show]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  def index
    @collection = Question.order('id desc').page(current_page).per(10)
  end

  def new
    @entity = Question.new
  end

  def create
    @entity = Question.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('questions.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('questions.destroy.success')
    end
    redirect_to questions_path
  end

  protected

  def restrict_editing
    raise UnauthorizedException unless @entity.editable_by? current_user
  end

  def set_entity
    @entity = Question.find params[:id]
  end

  def entity_parameters
    params.require(:question).permit(:answered, :body)
  end

  def creation_parameters
    parameters = entity_parameters.merge(owner_for_entity).merge(tracking_for_entity)
    parameters.reject! :answered if parameters.include? :answered
    parameters
  end
end
