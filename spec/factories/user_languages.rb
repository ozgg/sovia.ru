FactoryGirl.define do
  factory :user_language do
    association :user
    association :language
  end
end
