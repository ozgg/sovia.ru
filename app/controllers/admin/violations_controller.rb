class Admin::ViolationsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/violations
  def index
    @collection = Violation.page_for_administration current_page
  end

  # get /admin/violations/:id
  def show
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Violation.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find violation #{params[:id]}")
    end
  end
end
