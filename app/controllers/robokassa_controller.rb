# frozen_string_literal: true

# Handling Robokassa responses and callbacks
class RobokassaController < ApplicationController
  TEST_MODE = false

  skip_before_action :verify_authenticity_token, except: :create_invoice
  before_action :set_handler, except: %i[create_invoice pay_fail]

  # post /robokassa
  def create_invoice
    @entity = RobokassaInvoice.create(creation_parameters)
    @handler = component_handler.robokassa(@entity, TEST_MODE)
  end

  # post /robokassa/result
  def pay_result
    if @handler.valid_signature?(params[:SignatureValue], false, params[:out_summ])
      @handler.mark_as_paid
      result = "OK#{params[:InvId]}"
    else
      result = 'Bad signature'
    end

    event = "#{request.method} #{request.original_url}\n\t#{result}"
    Biovision::Components::Invoices::RobokassaHandler.log_event(event)

    render plain: result
  end

  # post /robokassa/success
  def pay_success
    if @handler.valid_signature?(params[:SignatureValue], true, params[:out_summ])
      render
    else
      render plain: 'Bad signature'
    end
  end

  # post /robokassa/fail
  def pay_fail
  end

  private

  def component_class
    Biovision::Components::InvoicesComponent
  end

  def set_handler
    @invoice = RobokassaInvoice.find_by(id: params[:InvId])
    if @invoice.nil?
      render plain: 'Cannot find invoice', status: :not_found
    else
      @handler = component_handler.robokassa(@invoice, TEST_MODE)
    end

    event = "#{request.method} #{request.original_url}\n\t#{params.inspect}"
    Biovision::Components::Invoices::RobokassaHandler.log_event(event)
  end

  def creation_parameters
    quantity = param_from_request(:q).to_i
    attributes = {
      price: Biovision::Components::DreamsComponent.price_map[quantity],
      email: current_user.email,
      data: {
        sovia: {
          Biovision::Components::DreamsComponent::REQUEST_COUNTER => quantity
        }
      }
    }

    attributes.merge(owner_for_entity(true))
  end
end
