FactoryGirl.define do
  factory :comment do
    language
    association :commentable, factory: :dream
    body "Someone's comment"
  end
end
