FactoryGirl.define do
  factory :grain do
    language
    user
    sequence(:name) { |n| "Grain #{n}" }
  end
end
