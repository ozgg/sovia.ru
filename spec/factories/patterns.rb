FactoryGirl.define do
  factory :pattern do
    sequence (:name) { |n| "Образ #{n}" }
  end
end
