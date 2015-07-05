FactoryGirl.define do
  factory :language do
    sequence(:code) { |n| "lng#{n}" }
    slug 'random_language'

    factory :russian_language do
      code 'ru'
      slug 'russian'
    end

    factory :english_language do
      code 'en'
      slug 'english'
    end
  end

end
