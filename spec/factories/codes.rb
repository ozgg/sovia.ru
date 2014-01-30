# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :code do
    code_type Code::TYPE_EMAIL_CONFIRMATION
    sequence(:body) { |n| "code_#{n}" }

    factory :email_confirmation do
      user
      code_type Code::TYPE_EMAIL_CONFIRMATION
    end
  end
end
