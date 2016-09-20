FactoryGirl.define do
  factory :user do
    network User.networks[:native]
    sequence(:screen_name) { |n| "User_#{n}" }
    sequence(:slug) { |n| "user_#{n}" }
    password 'secret'
    password_confirmation 'secret'

    factory :unconfirmed_user do
      sequence(:email) { |n| "user#{n}@example.com" }

      factory :confirmed_user do
        email_confirmed true
      end
    end

    factory :administrator do
      after :create do |user|
        create :user_role, user: user, role: :administrator
      end
    end

    factory :moderator do
      after :create do |user|
        create :user_role, user: user, role: :moderator
      end
    end

    factory :chief_editor do
      after :create do |user|
        create :user_role, user: user, role: :chief_editor
      end
    end

    factory :editor do
      after :create do |user|
        create :user_role, user: user, role: :editor
      end
    end
  end
end
