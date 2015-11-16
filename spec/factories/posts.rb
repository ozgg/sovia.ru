FactoryGirl.define do
  factory :post do
    user
    title 'Публикация для проверки'
    lead 'Эта публикация используется в тестах'
    body 'Это тело проверочной публикации'

    factory :hidden_post do
      show_in_list false
    end
  end
end
