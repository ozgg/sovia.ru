FactoryBot.define do
  factory :pattern do
    uuid { "" }
    user { nil }
    agent { nil }
    ip_address { nil }
    simple_image { nil }
    visible { false }
    processed { false }
    dream_count { 1 }
    name { "MyString" }
    essence { "MyString" }
    body { "MyText" }
    data { "" }
  end
end
