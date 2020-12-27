FactoryBot.define do
  factory :interpretation_message do
    uuid { "" }
    interpretation { nil }
    from_user { false }
    body { "MyText" }
  end
end
