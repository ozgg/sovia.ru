FactoryGirl.define do
  factory :post do
    user
    title 'Публикация о чём-то'
    lead "Аннотация публикации о чём-то"
    body "Текст публикации о чём-то"
  end
end
