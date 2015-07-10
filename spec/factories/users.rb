FactoryGirl.define do
  factory :user do
    association :language, factory: :russian_language
    network 0
    sequence(:screen_name) { |n| "User_#{n}" }
    password 'secret'
    password_confirmation 'secret'

    factory :unconfirmed_user do
      sequence(:email) { |n| "user-#{n}@example.com" }

      factory :confirmed_user do
        email_confirmed true
      end
    end
  end
end
