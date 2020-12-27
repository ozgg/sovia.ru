FactoryBot.define do
  factory :dream do
    uuid { "" }
    user { nil }
    simple_image { nil }
    agent { nil }
    ip_address { nil }
    sleep_place { nil }
    interpreted { false }
    lucidity { 1 }
    privacy { 1 }
    title { "MyString" }
    body { "MyText" }
    data { "" }
  end
end
