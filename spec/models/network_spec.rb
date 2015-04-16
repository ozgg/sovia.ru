require 'rails_helper'

RSpec.describe Network, type: :model do
  it 'is invalid without name' do
    network = build :network, name: ' '
    expect(network).not_to be_valid
  end

  it 'is invalid with non-unique name' do
    network = create :network
    expect(build :network, name: network.name).not_to be_valid
  end

  it 'is valid with valid attributes' do
    expect(build :network).to be_valid
  end
end
