# frozen_string_literal: true

# Manage dream interpretation requests
class Admin::InterpretationsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/interpretations
  def index
    @collection = Interpretation.page_for_administration(current_page)
  end

  # get /admin/interpretations/:id
  def show
  end

  # post /admin/interpretations/:id/messages
  def create_message
    message = @entity.interpretation_messages.new(message_parameters)
    message.from_user = false
    if message.save
      InterpretationMailer.new_message_from_interpreter(message.id).deliver_later
      render json: { meta: { result: t('.success'), ok: true } }
    else
      render json: { meta: { result: t('.error'), ok: false } }
    end
  end

  private

  def component_class
    Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = Interpretation.find_by(id: params[:id])
    handle_http_404('Cannot find interpretation') if @entity.nil?
  end

  def message_parameters
    permitted = InterpretationMessage.entity_parameters
    params.require(:interpretation_message).permit(permitted)
  end
end
