# frozen_string_literal: true

module Biovision
  module Components
    module Invoices
      module Paypal
        # Validating PayPal webhooks
        class HookHandler
          include PayPal::SDK::REST
          include PayPal::SDK::Core::Logging

          # @param [ActionDispatch::Http::Headers] headers
          # @param [String] body
          def initialize(headers, body)
            @parts = [
              headers['Paypal-Transmission-Id'],
              headers['Paypal-Transmission-Time'],
              webhook_id,
              body,
              headers['Paypal-Cert-Url'],
              headers['Paypal-Transmission-Sig'],
              headers['Paypal-Auth-Algo'].to_s.sub(/withRSA/i, '')
            ]
          end

          def webhook_id
            key = Rails.env.production? ? :live : :sandbox
            Rails.application.credentials.paypal.dig(key, :webhook_id)
          end

          def valid?
            WebhookEvent.verify(*@parts)
          end

          # @param [Hash] data
          def handle(data)
            id = data.dig(:resource, :id)
            event = PaypalEvent.new(data: data)
            if data[:resource_type] == 'payment'
              invoice = PaypalInvoice[id]
              handle_payment(id, data.dig(:resource, :status))
              event.paypal_invoice = invoice
            end
            event.save
          end

          private

          # @param [PaypalInvoice] invoice
          # @param [String] status
          def handle_payment(invoice, status)
            return if invoice.nil?

            component = Biovision::Components::InvoicesComponent[nil]
            component.mark_as_paid(invoice) if status == 'created'
          end
        end
      end
    end
  end
end
