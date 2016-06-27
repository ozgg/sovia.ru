require 'rails_helper'

RSpec.shared_examples_for 'entity_assigner' do
  it 'assigns entity to @entity' do
    expect(assigns[:entity]).to eq(entity)
  end
end
