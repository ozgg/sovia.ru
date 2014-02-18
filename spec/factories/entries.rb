FactoryGirl.define do
  factory :entry do
    entry_type
    body 'Текст записи с разным текстом'

    factory :owned_entry do
      user

      factory :protected_entry do
        privacy Entry::PRIVACY_USERS
      end

      factory :private_entry do
        privacy Entry::PRIVACY_OWNER
      end
    end
  end
end
