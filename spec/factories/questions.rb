FactoryGirl.define do
  factory :question do
    association :user, factory: :unconfirmed_user
    association :language, factory: :russian_language
    body "What is that?"
  end
end
