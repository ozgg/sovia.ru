# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_tag do
    user nil
    tag nil
    entries_count 1
  end
end
