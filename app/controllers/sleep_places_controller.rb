# frozen_string_literal: true

# Managing sleep places for users
class SleepPlacesController < ProfileController
  before_action :set_entity, only: %i[edit update destroy]
  before_action :check_place_limit, only: %i[new create]

  # post /sleep_places/check
  def check
    @entity = SleepPlace.instance_for_check(params[:entity_id], creation_parameters)

    render 'shared/forms/check'
  end

  # get /sleep_places/new
  def new
    @entity = SleepPlace.new
  end

  # post /sleep_places
  def create
    @entity = SleepPlace.new(creation_parameters)
    if @entity.save
      form_processed_ok(my_sleep_place_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /sleep_places/:id/edit
  def edit
  end

  # patch /sleep_places/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(my_sleep_place_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /sleep_places/:id
  def destroy
    flash[:notice] = t('sleep_places.destroy.success') if @entity.destroy
    redirect_to(my_sleep_places_path)
  end

  protected

  def set_entity
    @entity = SleepPlace.owned_by(current_user).find_by(id: params[:id])
    handle_http_404('Cannot find sleep_place') if @entity.nil?
  end

  def entity_parameters
    params.require(:sleep_place).permit(SleepPlace.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity)
  end

  def check_place_limit
    return if component_handler.can_add_sleep_place?

    flash[:alert] = t('sleep_places.new.limit_reached')
    redirect_to my_sleep_places_path
  end

  def component_slug
    Biovision::Components::DreamsComponent::SLUG
  end
end
