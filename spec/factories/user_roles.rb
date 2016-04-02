FactoryGirl.define do
  factory :user_role do
    user
    role UserRole.roles.values.first
  end
end
