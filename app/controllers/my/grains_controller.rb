class My::GrainsController < ApplicationController
  before_action :restrict_anonymous_access
  before_action :set_entity, except: [:index]

  # get /my/grains
  def index
    @collection = Grain.page_for_owner current_user, current_page
  end

  # get /my/grains/:id
  def show
  end

  # get /my/grains/:id/dreams
  def dreams
    @collection = @entity.dreams.page_for_owner(current_user, current_page)
  end

  private

  def set_entity
    @entity = Grain.find params[:id]
    raise record_not_found unless @entity.owned_by? current_user
  end
end
