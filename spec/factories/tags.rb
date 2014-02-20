FactoryGirl.define do
  factory :tag do
    name 'Нечто Интересное'

    factory :dream_tag, class: Tag::Dream do

    end

    factory :article_tag, class: Tag::Article do

    end

    factory :post_tag, class: Tag::Post do

    end

    factory :thought_tag, class: Tag::Thought do

    end
  end
end
