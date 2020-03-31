# frozen_string_literal: true

module Biovision
  module Components
    module Invoices
      # Handling robokassa invoices
      class RobokassaHandler
        LOGIN = Rails.application.credentials.robokassa[:login]

        attr_accessor :course, :test_mode, :price, :invoice, :invoice_id, :user

        # @param [RobokassaInvoice] invoice
        # @param [TrueClass|FalseClass] test_mode use test mode
        def initialize(invoice, test_mode = false)
          @test_mode = test_mode
          key = test_mode ? :test : :prod
          @password1  = Rails.application.credentials.robokassa[key][:password1]
          @password2  = Rails.application.credentials.robokassa[key][:password2]
          @invoice_id = invoice.id
          @user       = invoice.user
          @invoice    = invoice
        end

        # @param [String] string
        def self.log_event(string)
          File.open("#{Rails.root}/log/robokassa.log", 'a') do |file|
            file.puts "#{Time.now.strftime('%F %T')}\n\t#{string}\n-----\n"
          end
        end

        def is_test
          test_mode ? '1' : '0'
        end

        def out_sum
          @invoice.price.to_f.to_s
        end

        def signature
          parts = [LOGIN, out_sum, @invoice_id, @password1]
          Digest::MD5.hexdigest(parts.join(':'))
        end

        # @param [String] text
        # @param [TrueClass|FalseClass] alternative
        def valid_signature?(text, alternative = false, used_sum = out_sum)
          parts  = [used_sum, invoice_id, alternative ? @password1 : @password2]
          sample = Digest::MD5.hexdigest(parts.join(':'))

          sample.casecmp(text).zero?
        end

        def request_count
          key = Biovision::Components::DreamsComponent::REQUEST_COUNTER
          @invoice.data.dig('sovia', key).to_i
        end

        def mark_as_paid
          RobokassaHandler.log_event("Marking invoice #{@invoice.id} as paid")

          @invoice.update! state: RobokassaInvoice.states[:paid]

          handler = Biovision::Components::DreamsComponent[@user]
          new_count = handler.request_count + request_count
          handler.request_count = new_count
        end
      end
    end
  end
end
