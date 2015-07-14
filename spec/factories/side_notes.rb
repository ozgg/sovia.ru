FactoryGirl.define do
  factory :side_note do
    language
    user
    link "https://example.com"
    title "Another side note"
  end
end
