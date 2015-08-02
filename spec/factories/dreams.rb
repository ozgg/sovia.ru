FactoryGirl.define do
  factory :dream do
    language
    privacy Dream.privacies[:generally_accessible]
    body 'Какой-то сон для проверки'

    factory :owned_dream do
      association :user, factory: :unconfirmed_user

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
