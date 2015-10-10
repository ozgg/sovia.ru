FactoryGirl.define do
  factory :pattern do
    sequence (:name) { |n| "Образ #{n}" }

    factory :described_pattern do
      description 'Какое-то описание'
    end
  end
end
