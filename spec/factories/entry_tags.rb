# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :posts_entry_tag, :class => 'PostsEntryTags' do
    post nil
    entry_tag nil
  end
end
