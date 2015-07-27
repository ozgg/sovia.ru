require 'rails_helper'

shared_examples_for 'page_for_user' do
  it 'restricts anonymous access' do
    expect(controller).to have_received(:restrict_anonymous_access)
  end
end
