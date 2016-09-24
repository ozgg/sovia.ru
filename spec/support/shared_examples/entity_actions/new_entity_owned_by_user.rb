require 'rails_helper'

RSpec.shared_examples_for 'new_entity_owned_by_user' do
  it 'sets owner for created entity' do
    expect(entity.class.last).to be_owned_by(user)
  end
end
