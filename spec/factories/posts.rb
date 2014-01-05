FactoryGirl.define do
  factory :post do
    body 'Текст записи с разным текстом'

    factory :article do
      user
      title 'Статья о чём-то интересном'
    end

    factory :dream do
      body 'Что-то такое приснилось'

      factory :owned_dream do
        user

        factory :protected_dream do
          privacy Post::PRIVACY_USERS
        end

        factory :private_dream do
          privacy Post::PRIVACY_OWNER
        end
      end
    end
  end
end
