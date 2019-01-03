# frozen_string_literal: true

# Managing dreams for users
class DreamsController < ApplicationController
  before_action :set_entity, only: %i[edit update destroy]

  # post /dreams/check
  def check
    @entity = Dream.instance_for_check(params[:entity_id], creation_parameters)

    render 'shared/forms/check'
  end

  # get /dreams/new
  def new
    @entity = Dream.new
  end

  # post /dreams
  def create
    @entity = Dream.new(creation_parameters)
    if @entity.save
      form_processed_ok(my_dream_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /dreams/:id/edit
  def edit
  end

  # patch /dreams/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(my_dream_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /dreams/:id
  def destroy
    flash[:notice] = t('dreams.destroy.success') if @entity.destroy
    redirect_to(my_dreams_path)
  end

  protected

  def set_entity
    @entity = Dream.owned_by(current_user).find_by(id: params[:id])
    handle_http_404('Cannot find dream') if @entity.nil?
  end

  def restrict_editing
    redirect_to dreams_path unless @entity.editable_by?(current_user)
  end

  def entity_parameters
    params.require(:dream).permit(Dream.entity_parameters(current_user))
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity)
  end
end
