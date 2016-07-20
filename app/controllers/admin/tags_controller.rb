class Admin::TagsController < ApplicationController
  before_action :restrict_access

  # get /admin/tags
  def index
    @collection = Tag.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :chief_editor, :editor
  end
end
