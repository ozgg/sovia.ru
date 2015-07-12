FactoryGirl.define do
  factory :post do
    language
    user
    title 'Post for test'
    lead 'This is a post used in tests'
    body 'Testing post body'
  end
end