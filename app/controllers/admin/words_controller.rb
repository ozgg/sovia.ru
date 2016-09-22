class Admin::WordsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/words
  def index
    @filter     = params[:filter] || Hash.new
    @collection = Word.page_for_administration current_page, @filter
  end

  # get /admin/words/:id
  def show
  end

  # get /admin/words/:id/dreams
  def dreams
    # @collection = @entity.dreams.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_entity
    @entity = Word.find params[:id]
  end
end
