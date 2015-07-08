FactoryGirl.define do
  factory :agent do
    sequence(:name) { |n| "Crawler/#{n}" }
  end
end
