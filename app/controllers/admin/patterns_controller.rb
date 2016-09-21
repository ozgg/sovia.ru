class Admin::PatternsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/patterns
  def index
    @collection = Pattern.page_for_administration current_page
  end

  # get /admin/patterns/:id
  def show
  end

  # get /admin/patterns/:id/dreams
  def dreams
    # @collection = @entity.dreams.page_for_administration current_page
  end

  # get /admin/patterns/:id/comments
  def comments
    # @collection = @entity.comments.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_entity
    @entity = Pattern.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
