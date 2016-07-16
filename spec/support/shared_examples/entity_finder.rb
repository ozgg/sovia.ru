require 'rails_helper'

RSpec.shared_examples_for 'entity_finder' do
  it 'calls ::find on entity class' do
    expect(entity.class).to have_received(:find)
  end
end
