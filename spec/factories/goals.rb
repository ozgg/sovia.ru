FactoryGirl.define do
  factory :goal do
    user
    name 'Быть лучше'
    status Goal.statuses[:issued]
  end
end
