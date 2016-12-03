class Admin::FillersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/fillers
  def index
    @collection = Filler.page_for_administration current_page
  end

  # get /admin/fillers/:id
  def show
  end

  private

  def restrict_access
    require_role :chief_editor, :editor
  end

  def set_entity
    @entity = Filler.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find filler #{params[:id]}")
    end
  end
end
