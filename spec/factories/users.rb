FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "random_guy#{n}" }
    password 'secret'
    password_confirmation 'secret'

    factory :unconfirmed_user do
      sequence(:email) { |n| "no-reply#{n}@example.com" }

      factory :confirmed_user do
        mail_confirmed true
      end
    end

    factory :posts_manager do
      after(:create) do |user|
        user.roles = { :posts_manager => 1 }
      end
    end

    factory :administrator do
      after(:create) do |user|
        user.roles = { :administrator => 1 }
      end
    end
  end
end
