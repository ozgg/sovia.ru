FactoryGirl.define do
  factory :dream_pattern do
    dream
    pattern
    status DreamPattern.statuses[:by_owner]

    factory :suggested_dream_pattern do
      status DreamPattern.statuses[:suggested]
    end

    factory :rejected_dream_pattern do
      status DreamPattern.statuses[:rejected]
    end

    factory :forced_dream_pattern do
      status DreamPattern.statuses[:forced]
    end
  end
end
