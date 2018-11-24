FactoryBot.define do
  factory :dream do
    user { nil }
    sleep_place { nil }
    agent { nil }
    ip { "" }
    visible { false }
    needs_interpretation { false }
    personal_interpretation { false }
    interpreted { false }
    lucidity { 1 }
    mood { 1 }
    privacy { 1 }
    title { "MyString" }
    slug { "MyString" }
    body { "MyText" }
  end
end
