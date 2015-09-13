FactoryGirl.define do
  factory :grain do
    user
    sequence(:name) { |n| "Образ #{n}" }
  end
end
