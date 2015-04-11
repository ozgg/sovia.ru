FactoryGirl.define do
  factory :answer do
    question
    association :owner, factory: :unconfirmed_user
    body "All problems solved"
  end
end
