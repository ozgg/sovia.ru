FactoryGirl.define do
  factory :question do
    user
    association :language, factory: :russian_language
    text "What is that?"
  end
end
