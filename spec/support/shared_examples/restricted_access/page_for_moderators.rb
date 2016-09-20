require 'rails_helper'

RSpec.shared_examples_for 'page_for_moderators' do
  it 'requires moderator roles' do
    expect(subject).to have_received(:require_role).with(:administrator, :moderator)
  end
end
