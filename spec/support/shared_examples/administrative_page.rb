require 'rails_helper'

RSpec.shared_examples_for 'administrative_page' do
  it 'requires role administrator' do
    expect(controller).to have_received(:require_role).with(:administrator)
  end
end
