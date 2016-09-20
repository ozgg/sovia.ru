require 'rails_helper'

RSpec.shared_examples_for 'entity_not_deleted' do
  it 'does not mark entity as deleted' do
    entity.reload
    expect(entity).not_to be_deleted
  end
end
