FactoryGirl.define do
  factory :pattern do
    association :language, factory: :russian_language
    sequence(:name) { |n| "pattern #{n}" }

    factory :described_pattern do
      body 'This pattern has description'
    end
  end
end
