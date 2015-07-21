FactoryGirl.define do
  factory :code do
    user
    category 0

    factory :recovery_code do
      category Code.categories[:recovery]
    end

    factory :confirmation_code do
      category Code.categories[:confirmation]
    end
  end
end
