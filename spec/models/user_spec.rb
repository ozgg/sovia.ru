require 'rails_helper'

RSpec.describe User, type: :model, wip: true do
  context 'before validating' do
    it 'normalizes email' do
      user = User.new email: 'USERNAME@example.com'
      user.valid?
      expect(user.email).to eq('username@example.com')
    end

    it 'normalizes screen name for native account' do
      user = User.new network: :native, screen_name: 'USER_1'
      user.valid?
      expect(user.uid).to eq('user_1')
    end

    it 'leaves non-native uid intact' do
      user = User.new network: :vk, screen_name: 'Maxim_KM', uid: '1234'
      user.valid?
      expect(user.uid).to eq('1234')
    end
  end

  context 'validating' do
    it 'fails without uid'
    it 'fails with unreasonable email'
    it 'fails with malformed native uid'
    it 'fails with non-unique native uid'
  end
end
