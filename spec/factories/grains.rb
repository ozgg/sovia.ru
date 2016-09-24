FactoryGirl.define do
  factory :grain do
    user
    sequence(:name) { |n| "Личный образ #{n}" }
  end
end
