require 'rails_helper'

RSpec.shared_examples_for 'page_for_administrator' do
  it 'requires role administrator' do
    expect(subject).to have_received(:require_role).with(:administrator)
  end
end
