FactoryGirl.define do
  factory :word do
    sequence(:body) { |n| "слово-#{n}" }
  end
end
