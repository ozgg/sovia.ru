FactoryGirl.define do
  factory :language do
    factory :russian_language do
      code 'ru'
      name 'russian'
    end

    factory :english_language do
      code 'en'
      name 'english'
    end
  end
end
