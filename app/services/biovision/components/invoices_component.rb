# frozen_string_literal: true

module Biovision
  module Components
    # Handling invoices
    class InvoicesComponent < BaseComponent
      include PayPal::SDK::REST

      attr_accessor :url_prefix

      # @param [RobokassaInvoice] invoice
      # @param [TrueClass|FalseClass] test_mode
      def robokassa(invoice, test_mode = false)
        Biovision::Components::Invoices::RobokassaHandler.new(invoice, test_mode)
      end

      # @param [Hash] parameters
      def create_invoice(parameters)
        @invoice = ::PaypalInvoice.new(parameters)
        create_payment
        @invoice.save
        @invoice
      end

      # @param [Invoice] entity
      def mark_as_paid(entity)
        return if entity.paid? || entity.data.dig('frozen')

        entity.paid = true
        entity.data['frozen'] = true
        entity.save!
        increment_request_count(entity.user, entity.quantity)
      end

      # @param [Invoice] entity
      def mark_as_cancelled(entity)
        return if entity.paid? || entity.data.dig('frozen')

        entity.data['frozen'] = true
        entity.data['state'] = 'cancelled'
        entity.save!
      end

      # @param [User] user
      # @param [Integer] delta
      def increment_request_count(user, delta)
        key = Biovision::Components::DreamsComponent::REQUEST_COUNTER
        user.data['sovia'] ||= {}
        data = user.data['sovia']
        data[key] = 0 unless data.key?(key)
        new_value = data[key].to_i + delta

        user.data['sovia'][key] = new_value
        user.save
      end

      private

      def create_payment
        initialize_payment

        if @payment.create
          @invoice.data['paypal'] = {
            id: @payment.id,
            links: @payment.links.map { |l| [l.rel, l.href] }.to_h
          }
        else
          Rails.logger.warn @payment.error.inspect
        end
      end

      def initialize_payment
        @payment = Payment.new(
          intent: 'sale',
          payer: { payment_method: 'paypal' },
          redirect_urls: redirect_urls,
          transactions: [transaction_data]
        )
      end

      def transaction_data
        {
          item_list: { items: [item_data] },
          amount: { total: @invoice.amount.to_s, currency: 'RUB' },
          description: "#{@invoice.quantity}x dream interpretation requests"
        }
      end

      def item_data
        {
          name: "#{@invoice.quantity}x dream interpretation requests",
          sku: "DI-#{@invoice.quantity}",
          price: @invoice.amount.to_s,
          currency: 'RUB',
          quantity: 1
        }
      end

      def redirect_urls
        {
          return_url: "#{url_prefix}/paypal/#{@invoice.uuid}/success",
          cancel_url: "#{url_prefix}/paypal/#{@invoice.uuid}/cancel"
        }
      end
    end
  end
end
