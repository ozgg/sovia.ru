FactoryBot.define do
  factory :paypal_event do
    paypal_invoice { nil }
    data { "" }
  end
end
