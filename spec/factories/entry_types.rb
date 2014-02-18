FactoryGirl.define do
  factory :entry_type do
    name ('a'..'z').to_a.shuffle[0, 10].join

    factory :entry_type_dream do
      name 'dream'
    end

    factory :entry_type_article do
      name 'article'
    end

    factory :entry_type_post do
      name 'post'
    end

    factory :entry_type_thought do
      name 'thought'
    end
  end
end
