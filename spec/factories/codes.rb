FactoryGirl.define do
  factory :code do
    sequence(:body) { |n| "code_#{n}" }

    factory :email_confirmation do
      association :user, factory: :unconfirmed_user
      code_type Code::TYPE_EMAIL_CONFIRMATION
    end

    factory :password_recovery do
      association :user, factory: :confirmed_user
      code_type Code::TYPE_PASSWORD_RECOVERY
    end
  end
end
