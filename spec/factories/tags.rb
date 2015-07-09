FactoryGirl.define do
  factory :tag do
    association :language, factory: :russian_language
    sequence(:name) { |n| "Метка #{n}" }
  end
end
