FactoryGirl.define do
  factory :code do
    user
    category Code.categories[:recovery]

    factory :recovery_code do
      association :user, factory: :unconfirmed_user
      category Code.categories[:recovery]
    end

    factory :confirmation_code do
      association :user, factory: :unconfirmed_user
      category Code.categories[:confirmation]
    end
  end
end
