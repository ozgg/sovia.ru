class PaypalEvent < ApplicationRecord
  belongs_to :paypal_invoice
end
