require 'rails_helper'

RSpec.shared_examples_for 'excluded_foreign_entity' do
  it 'does not add foreign entity to @collection' do
    expect(assigns[:collection]).not_to include(foreign_entity)
  end
end
