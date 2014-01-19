FactoryGirl.define do
  factory :post do
    entry_type Post::TYPE_POST
    body 'Текст записи с разным текстом'

    factory :owned_post do
      user

      factory :protected_post do
        privacy Post::PRIVACY_USERS
      end

      factory :private_post do
        privacy Post::PRIVACY_OWNER
      end
    end
  end
end
