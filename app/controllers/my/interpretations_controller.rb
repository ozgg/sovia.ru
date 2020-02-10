# frozen_string_literal: true

# List and create dream interpretation requests
class My::InterpretationsController < ProfileController
  before_action :set_entity, except: %i[create index]

  # get /my/interpretations
  def index
    @collection = Interpretation.page_for_owner(current_user, current_page)
  end

  # post /my/interpretations
  def create
    dream_id = param_from_request(:dream_id)
    result = component_handler.request_interpretation(dream_id)

    render json: { meta: { result: t(".#{result}", default: result.to_s) } }
  end

  # get /my/interpretations/:id
  def show
  end

  # post /my/interpretations/:id/messages
  def create_message
    message = @entity.interpretation_messages.new(message_parameters)
    message.from_user = true
    if message.save
      InterpretationMailer.new_message_from_user(message.id).deliver_later
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
    @entity = Interpretation.owned_by(current_user).find_by(id: params[:id])
    handle_http_404('Cannot find interpretation') if @entity.nil?
  end

  def message_parameters
    permitted = InterpretationMessage.entity_parameters
    params.require(:interpretation_message).permit(permitted)
  end
end
