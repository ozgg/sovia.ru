FactoryGirl.define do
  factory :token do
    user
    sequence(:token) { |n| "token#{n}" }
  end
end
