FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "Метка #{n}" }
  end
end
