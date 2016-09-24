class Admin::GrainCategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/grain_categories
  def index
    @collection = GrainCategory.page_for_administration
  end

  # get /admin/grain_categories/:id
  def show
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = GrainCategory.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
