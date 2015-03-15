FactoryGirl.define do
  factory :agent_request do
    agent
    day DateTime.now
    requests_count 1
  end
end
