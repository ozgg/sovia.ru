FactoryGirl.define do
  factory :grain do
    user
    pattern nil
    sequence(:name) { |n| "grain #{n}" }

    factory :described_grain do
      body 'This grain has description'
    end
  end

end
