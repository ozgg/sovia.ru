class Admin::PostsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/posts
  def index
    @collection = Post.page_for_administration current_page
  end

  # get /admin/posts/:id
  def show
  end

  # get /admin/posts/:id/comments
  def comments
    @collection = @entity.comments.page_for_administration(current_page)
  end

  private

  def restrict_access
    require_role :chief_editor, :editor
  end

  def set_entity
    @entity = Post.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
