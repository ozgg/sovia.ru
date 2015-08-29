FactoryGirl.define do
  factory :side_note do
    language
    user
    link "https://example.com"
    title "Another side note"

    factory :active_side_note do
      active true
    end
  end
end
