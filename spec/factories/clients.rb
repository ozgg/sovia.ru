FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "Client #{n}" }
    secret '0000-0000-0'
  end
end
