FactoryGirl.define do
  factory :grain_category do
    sequence(:name) { |n| "Категория образа #{n}" }
  end
end
