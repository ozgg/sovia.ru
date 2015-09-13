FactoryGirl.define do
  factory :side_note do
    user
    link 'https://example.com'
    title 'Очередная заметка на полях'

    factory :active_side_note do
      active true
    end
  end
end
