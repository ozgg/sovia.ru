FactoryGirl.define do
  factory :post do
    body 'Текст записи с разным текстом'

    factory :article do
      user
      type Post::TYPE_ARTICLE
      title 'Статья о чём-то интересном'
    end

    factory :dream do
      type Post::TYPE_DREAM
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
