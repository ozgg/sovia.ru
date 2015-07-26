FactoryGirl.define do
  factory :dream do
    language
    privacy 0
    mood 0
    body 'Какой-то сон для проверки'

    factory :personal_dream do
      privacy Dream.privacies[:personal]
    end
  end
end
