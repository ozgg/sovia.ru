FactoryGirl.define do
  factory :agent_request do
    agent
    day "2015-03-15"
    requests_count 1
  end
end
