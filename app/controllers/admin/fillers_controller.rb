# frozen_string_literal: true

# List and view fillers
class Admin::FillersController < AdminController
  before_action :set_entity, except: :index

  # get /admin/fillers
  def index
    @collection = Filler.page_for_administration(current_page)
  end

  # get /admin/fillers/:id
  def show
  end

  private

  def component_class
    Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = Filler.find_by(id: params[:id])
    handle_http_404("Cannot find filler #{params[:id]}") if @entity.nil?
  end
end
