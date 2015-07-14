FactoryGirl.define do
  factory :pattern_link do
    pattern
    association :target, factory: :pattern
    category 0
  end
end
