require 'rails_helper'

RSpec.shared_examples_for 'entity_unlocker' do
  it_behaves_like 'http_success'

  it 'unlocks entity' do
    entity.reload
    expect(entity).not_to be_locked
  end
end
