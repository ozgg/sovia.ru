FactoryGirl.define do
  factory :post do
    user
    language
    title "Post from factory"
    body "This is a post\n\nAnother passage"

    factory :post_with_lead do
      lead "This is a post with lead"
    end
  end
end
