FactoryGirl.define do
  factory :question do
    association :owner, factory: :unconfirmed_user
    association :language, factory: :russian_language
    body "What is that?"
  end
end
