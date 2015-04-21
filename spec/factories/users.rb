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
      after :create do |user|
        user.roles = { posts_manager: 1 }
      end
    end

    factory :moderator do
      after :create do |user|
        user.roles = { moderator: 1 }
      end
    end

    factory :administrator do
      after :create do |user|
        user.roles = { administrator: 1 }
      end
    end

    factory :content_editor do
      after :create do |user|
        user.roles = { content_editor: 1 }
      end
    end

    factory :dreambook_editor do
      after :create do |user|
        user.roles = { dreambook_editor: 1 }
      end
    end

    factory :dreambook_manager do
      after :create do |user|
        user.roles = { dreambook_editor: 1 }
      end
    end
  end
end
