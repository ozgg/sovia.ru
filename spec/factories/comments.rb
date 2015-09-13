FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :dream
    body 'Чей-то комментарий'
  end
end
