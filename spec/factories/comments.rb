FactoryGirl.define do
  factory :comment do
    user
    association :commentable, factory: :post
    body 'Чей-то комментарий'
  end
end
