FactoryGirl.define do
  factory :comment do
    language
    association :commentable, factory: :post
    body "Someone's comment"
  end
end
