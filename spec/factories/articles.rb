FactoryGirl.define do
  factory :article do
    user
    title 'Статья о чём-то интересном'
    body 'Текст статьи, тут должно быть много текста'
  end
end
