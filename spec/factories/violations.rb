FactoryGirl.define do
  factory :violation do
    agent
    ip '127.0.0.1'
    category Violation.categories[:dreams_spam]
    body 'http://localhost/'
  end
end
