FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "random_guy#{n}" }
    password 'secret'
    password_confirmation 'secret'

    factory :editor do
      roles_mask User::ROLE_EDITOR
    end

    factory :moderator do
      roles_mask User::ROLE_MODERATOR
    end
  end
end
