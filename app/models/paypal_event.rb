# frozen_string_literal: true

# PayPal webhook event
#
# Attributes:
#   created_at [DateTime]
#   data [JSONB]
#   paypal_invoice_id [PaypalInvoice]
#   updated_at [DateTime]
class PaypalEvent < ApplicationRecord
  belongs_to :paypal_invoice, optional: true

  scope :recent, -> { order('id desc') }
  scope :list_for_administration, -> { recent }
end
