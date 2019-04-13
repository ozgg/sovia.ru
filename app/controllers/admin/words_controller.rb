# frozen_string_literal: true

# Administrative part of words management
class Admin::WordsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/words
  def index
    @collection = Word.page_for_administration(current_page)
  end

  # get /admin/words/:id
  def show
  end

  private

  def restrict_access
    require_privilege_group :dreambook_managers
  end

  def set_entity
    @entity = Word.find_by(id: params[:id])
    handle_http_404('Cannot find word') if @entity.nil?
  end
end
