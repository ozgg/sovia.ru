require 'rails_helper'

RSpec.shared_examples_for 'entity_constant_count' do
  it 'does not change entity count' do
    expect(action).not_to change(entity.class, :count)
  end
end
