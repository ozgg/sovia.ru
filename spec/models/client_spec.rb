require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validation' do
    it 'fails with empty name' do
      client = build :client, name: ' '
      expect(client).not_to be_valid
    end

    it 'fails without secret' do
      client = build :client, secret: ' '
      expect(client).not_to be_valid
    end

    it 'fails with non-unique name' do
      client = create :client
      expect(build :client, name: client.name).not_to be_valid
    end

    it 'passes with valid attrubites' do
      expect(Client.new name: 'another', secret: 'a').to be_valid
    end
  end
end
