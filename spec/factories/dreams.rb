FactoryGirl.define do
  factory :dream do
    body 'Ещё один сон в тестах'

    factory :owned_dream do
      user

      factory :dream_for_community do
        privacy Dream.privacies[:visible_to_community]
      end

      factory :dream_for_followees do
        privacy Dream.privacies[:visible_to_followees]
      end

      factory :personal_dream do
        privacy Dream.privacies[:personal]
      end
    end
  end
end
