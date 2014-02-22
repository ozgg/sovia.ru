FactoryGirl.define do
  factory :code do
    sequence(:body) { |n| "code_#{n}" }

    factory :email_confirmation, class: Code::Confirmation do
      association :user, factory: :unconfirmed_user
    end

    factory :password_recovery, class: Code::Recovery do
      association :user, factory: :unconfirmed_user
    end
  end
end
