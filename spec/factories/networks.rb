FactoryGirl.define do
  factory :network do
    sequence(:name) { |n| "Network #{n}" }
  end
end
