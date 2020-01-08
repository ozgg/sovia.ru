FactoryBot.define do
  factory :interpretation_message do
    interpretation { nil }
    from_user { false }
    body { "MyText" }
  end
end
