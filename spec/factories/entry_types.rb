FactoryGirl.define do
  factory :entry_type do
    name ('a'..'z').to_a.shuffle[0, 10].join
  end
end
