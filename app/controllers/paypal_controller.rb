# frozen_string_literal: true

# Handling PayPal hooks
class PaypalController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :hook

  # post /paypal
  def hook
    File.open("#{Rails.root}/log/paypal.log", 'ab') do |f|
      f.puts Time.now
      f.puts request.headers
      f.puts params
      f.puts
    end

    head :no_content
  end

  # post /paypal
  def create_invoice
    component_handler.url_prefix = "#{request.protocol}#{request.host_with_port}"
    @entity = component_handler.create_invoice(creation_parameters)
    approval_url = @entity.data.dig('paypal', 'links', 'approval_url')
    if @entity.valid? && !approval_url.blank?
      render json: { links: { next: approval_url } }
    else
      head :unprocessable_entity
    end
  end

  # get /paypal/:id/success
  def success
    invoice = PaypalInvoice.find_by(uuid: params[:id])
    component_handler.mark_as_paid(invoice) unless invoice.nil?

    redirect_to my_path
  end

  # get /paypal/:id/cancel
  def cancel
    invoice = PaypalInvoice.find_by(uuid: params[:id])
    component_handler.mark_as_cancelled(invoice) unless invoice.nil?

    redirect_to my_path
  end

  private

  def component_class
    Biovision::Components::InvoicesComponent
  end

  def creation_parameters
    quantity = param_from_request(:q).to_i
    attributes = {
      amount: Biovision::Components::DreamsComponent.price_map[quantity],
      data: {
        sovia: {
          quantity: quantity
        }
      }
    }

    attributes.merge(owner_for_entity(true))
  end
end
