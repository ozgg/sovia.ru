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
  end
end
