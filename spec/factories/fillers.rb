FactoryGirl.define do
  factory :filler do
    queue 0
    association :language, factory: :russian_language
    body 'This will fill'
  end
end
