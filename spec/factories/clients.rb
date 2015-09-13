FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "Клиент #{n}" }
    secret '0000-0000-0'
  end
end
