require 'rails_helper'

RSpec.shared_examples_for 'entity_locker' do
  it_behaves_like 'http_success'

  it 'locks entity' do
    entity.reload
    expect(entity).to be_locked
  end
end
