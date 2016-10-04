class Admin::QuestionsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/questions
  def index
    @collection = Question.page_for_administration current_page
  end

  # get /admin/questions/:id
  def show
  end

  # get /admin/questions/:id/comments
  def comments
    @collection = @entity.comments.page_for_administration(current_page)
  end

  private

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_entity
    @entity = Question.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
