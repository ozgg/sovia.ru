FactoryGirl.define do
  factory :place do
    user
    sequence(:name) { |n| "Место #{n}" }
  end
end
