FactoryGirl.define do
  factory :answer do
    question
    association :user, factory: :unconfirmed_user
    association :owner, factory: :unconfirmed_user
    body "All problems solved"
  end
end
