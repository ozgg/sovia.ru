require 'rails_helper'

RSpec.shared_examples_for 'restricted_editing' do
  it 'calls #restrict_editing' do
    expect(subject).to have_received(:restrict_editing)
  end
end
