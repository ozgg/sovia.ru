FactoryGirl.define do
  factory :pattern do
    language
    sequence (:name) { |n| "Pattern #{n}" }
  end
end
