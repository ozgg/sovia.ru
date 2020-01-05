FactoryBot.define do
  factory :service do
    visible { false }
    highlighted { false }
    priority { 1 }
    active { false }
    name { "MyString" }
    slug { "MyString" }
    image { "MyString" }
    lead { "MyString" }
    description { "MyText" }
    data { "" }
    price { 1 }
    old_price { 1 }
    users_count { 1 }
  end
end
