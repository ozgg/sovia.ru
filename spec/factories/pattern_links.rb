FactoryGirl.define do
  factory :pattern_link do
    pattern
    association :target, factory: :pattern
    category PatternLink.categories[:see_instead]
  end
end
