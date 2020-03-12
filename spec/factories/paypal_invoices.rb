FactoryBot.define do
  factory :paypal_invoice do
    user { nil }
    agent { nil }
    ip { "" }
    uuid { "" }
    paid { false }
    amount { 1 }
    data { "" }
  end
end
