require 'rails_helper'

RSpec.shared_examples_for 'page_for_everybody' do
  it 'does not require any roles' do
    expect(subject).not_to have_received(:require_role)
  end
end
