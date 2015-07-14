require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_trace'

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
    it 'fails without uid' do
      user = build :user, network: :vk, uid: ' '
      expect(user).not_to be_valid
    end

    it 'fails with unreasonable email' do
      user = build :user, email: 'invalid'
      expect(user).not_to be_valid
    end

    it 'fails with malformed native uid' do
      user = build :user, uid: 'invalid uid', screen_name: nil
      expect(user).not_to be_valid
    end

    it 'fails with non-unique uid for network' do
      user = create :user
      expect(build :user, screen_name: user.screen_name.upcase).not_to be_valid
    end

    it 'passes with non-unique uid for defferent networks' do
      user = create :user
      expect(build :user, uid: user.uid, network: :vk).to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :user).to be_valid
    end
  end
end
