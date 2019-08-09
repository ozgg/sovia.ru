FactoryBot.define do
  factory :dream do
    user { nil }
    agent { nil }
    sleep_place { nil }
    ip { "" }
    body { "MyText" }
    lucidity { 1 }
    privacy { 1 }
    title { "MyString" }
    visible { false }
  end
end
