FactoryGirl.define do
  factory :entry do
    body 'Текст записи с разным текстом'

    factory :owned_entry do
      user

      factory :protected_entry do
        privacy Entry::PRIVACY_USERS
      end

      factory :private_entry do
        privacy Entry::PRIVACY_OWNER
      end

      factory :article, class: Entry::Article do
        title 'Какая-то статья'
      end

      factory :post, class: Entry::Post do
        factory :protected_post do
          privacy Entry::PRIVACY_USERS
        end

        factory :private_post do
          privacy Entry::PRIVACY_OWNER
        end
      end

      factory :thought, class: Entry::Thought do
        factory :protected_thought do
          privacy Entry::PRIVACY_USERS
        end

        factory :private_thought do
          privacy Entry::PRIVACY_OWNER
        end
      end
    end

    factory :dream, class: Entry::Dream do
      factory :owner_dream do
        user

        factory :protected_dream do
          privacy Entry::PRIVACY_USERS
        end

        factory :private_dream do
          privacy Entry::PRIVACY_OWNER
        end
      end
    end
  end
end
