FactoryGirl.define do
  factory :dream_factor do
    dream
    factor DreamFactor.factors[:activity]
  end
end
