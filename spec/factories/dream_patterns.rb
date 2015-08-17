FactoryGirl.define do
  factory :dream_pattern do
    dream
    pattern
    status DreamPattern.statuses[:by_owner]
  end
end
