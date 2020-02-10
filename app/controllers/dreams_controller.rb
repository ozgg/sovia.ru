# frozen_string_literal: true

# Managing dreams for users
class DreamsController < ApplicationController
  before_action :set_entity, only: %i[edit update destroy]
  before_action :restrict_editing, only: %i[edit update destroy]

  # post /dreams/check
  def check
    @entity = Dream.instance_for_check(params[:entity_id], creation_parameters)

    render 'shared/forms/check'
  end

  # get /dreams
  def index
    @collection = Dream.page_for_visitor(current_user, current_page)
  end

  # get /dreams/new
  def new
    @entity = Dream.new
  end

  # post /dreams
  def create
    @entity = Dream.new(creation_parameters)
    @entity.visible = false if @entity.suspect_spam?
    if @entity.save
      form_processed_ok(dream_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /dreams/:id
  def show
    @entity = Dream.find_by(id: params[:id])

    unless @entity&.visible_to?(current_user)
      handle_http_404("Cannot find dream visible to user #{current_user&.id}")
    end
  end

  # get /dreams/:id/edit
  def edit
  end

  # patch /dreams/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(dream_path(id: @entity.id))
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
    @entity = Dream.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find dream')
    elsif !component_handler.visible?(@entity)
      handle_http_404('Dream is not visible to current user')
    end
  end

  def restrict_editing
    redirect_to dreams_path unless component_handler.editable?(@entity)
  end

  def entity_parameters
    params.require(:dream).permit(Dream.entity_parameters(current_user))
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity(true))
  end

  def component_class
    Biovision::Components::DreamsComponent
  end
end
