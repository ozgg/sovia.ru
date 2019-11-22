FactoryBot.define do
  factory :filler do
    user { nil }
    gender { 1 }
    title { "MyString" }
    body { "MyText" }
  end
end
