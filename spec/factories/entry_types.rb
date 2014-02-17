# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry_type do
    name "MyString"
    entries_count 1
    tags_count 1
  end
end
