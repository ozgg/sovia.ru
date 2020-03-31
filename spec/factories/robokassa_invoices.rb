FactoryBot.define do
  factory :robokassa_invoice do
    user { nil }
    agent { nil }
    ip { "" }
    state { 1 }
    price { 1 }
    email { "MyString" }
    data { "" }
  end
end
