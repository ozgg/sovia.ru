class Admin::PostsController < ApplicationController
  before_action :restrict_access

  # get /admin/posts
  def index
    @collection = Post.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :chief_editor, :editor
  end
end
