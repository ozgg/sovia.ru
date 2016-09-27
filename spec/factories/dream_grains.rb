FactoryGirl.define do
  factory :dream_grain do
    association :dream, factory: :owned_dream

    after :build do |link|
      if link.grain.nil?
        link.grain = create :grain, user: link.dream.user
      end
    end
  end
end
