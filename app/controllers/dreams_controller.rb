class DreamsController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  def index

  end

  def new

  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  def tagged

  end

  protected

  def restrict_editing
    raise UnauthorizedException unless @entity.editable_by? current_user
  end

  def set_entity
    @entity = Dream.find params[:id].to_i
    raise record_not_found unless @entity.visible_to? current_user
  end

  def entity_parameters
    permitted = Dream.parameters_for_all
    permitted += Dream.parameters_for_users if current_user
    permitted += Dream.parameters_for_administrators if current_user_has_role? :administrator
    params.require(:dream).permit(permitted)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end
end
