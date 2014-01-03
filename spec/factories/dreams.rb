FactoryGirl.define do
  factory :dream do
    body 'Что-то такое приснилось'

    factory :owned_dream do
      user

      factory :protected_dream do
        privacy Dream::PRIVACY_USERS
      end

      factory :private_dream do
        privacy Dream::PRIVACY_OWNER
      end
    end
  end
end
