FactoryGirl.define do
  factory :places do
    association :user, factory: :unconfirmed_user
    association :language, factory: :russian_language
    name 'Моя кровать'
  end
end
