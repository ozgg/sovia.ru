require 'rails_helper'

RSpec.shared_examples_for 'collection_assigner' do
  it 'adds entity to @collection' do
    expect(assigns[:collection]).to include(entity)
  end
end
