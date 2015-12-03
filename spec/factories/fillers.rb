FactoryGirl.define do
  factory :filler do
    category Filler.categories[:question]
    body 'Another filler'
  end
end
