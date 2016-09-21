require 'rails_helper'

RSpec.shared_examples_for 'page_for_chief_interpreter' do
  it 'requires role chief_interpreter' do
    expect(subject).to have_received(:require_role).with(:chief_interpreter)
  end
end
