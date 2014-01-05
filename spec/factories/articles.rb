FactoryGirl.define do
  factory :article do
    user
    entry_type Post::TYPE_ARTICLE
    title 'Статья о чём-то интересном'
    body 'Интересная статья об интересном'
  end
end
