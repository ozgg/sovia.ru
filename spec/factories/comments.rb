FactoryBot.define do
  factory :comment do
    uuid { "" }
    user { nil }
    agent { nil }
    ip_address { nil }
    commentable_id { 1 }
    commentable_type { "MyString" }
    parent_id { 1 }
    visible { false }
    body { "MyText" }
    data { "" }
  end
end
