require 'rails_helper'

RSpec.shared_examples_for 'successful_response' do
  it 'responds with HTTP status 200' do
    expect(response).to be_success
  end
end
