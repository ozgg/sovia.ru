FactoryBot.define do
  factory :post do
    uuid { "" }
    user { nil }
    simple_image { nil }
    featured { false }
    title { "MyString" }
    slug { "MyString" }
    lead { "MyText" }
    body { "MyText" }
    source_name { "MyString" }
    source_link { "MyString" }
    data { "" }
  end
end
