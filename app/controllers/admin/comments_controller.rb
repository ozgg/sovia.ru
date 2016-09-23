class Admin::CommentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/comments
  def index
    @collection = Comment.page_for_administration current_page
  end

  # get /admin/comments/:id
  def show

  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Comment.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
