FactoryBot.define do
  factory :interpretation do
    uuid { "" }
    user { nil }
    dream { nil }
    solved { false }
    body { "MyText" }
  end
end
