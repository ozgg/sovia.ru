FactoryBot.define do
  factory :word do
    pattern { nil }
    processed { false }
    dreams_count { 1 }
    body { "MyString" }
  end
end
