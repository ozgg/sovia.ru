require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_trace'

  describe 'before validating' do
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

  describe 'validating' do
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

  describe '#has_role?' do
    it 'calls UserRole#user_has_role? for user and role' do
      user = create :user
      expect(UserRole).to receive(:user_has_role?).with(user, :role)
      user.has_role? :role
    end
  end

  describe '#add_role' do
    let(:user) { create :user }

    it 'inserts row into user_roles for absent pair' do
      expect { user.add_role :administrator }.to change(UserRole, :count).by(1)
    end

    it 'leaves table intact for existing pair' do
      create :user_role, user: user, role: :administrator
      expect { user.add_role :administrator }.not_to change(UserRole, :count)
    end

    it 'leaves table intact for non-existing role' do
      expect { user.add_role :non_existent }.not_to change(UserRole, :count)
    end
  end

  describe '#remove_role' do
    let(:user) { create :user }

    before :each do
      create :user_role, user: user, role: :administrator
    end

    it 'removes row from user_role for existing pair' do
      expect { user.remove_role :administrator }.to change(UserRole, :count).by(-1)
    end

    it 'leaves table intact for absent pair' do
      expect { user.remove_role :moderator }.not_to change(UserRole, :count)
    end

    it 'leaves table intact for invalid role' do
      expect { user.remove_role :non_existent }.not_to change(UserRole, :count)
    end
  end

  describe '#add_language' do
    let(:user) { create :user }

    before(:each) { create :user_language, user: user, language: user.language }

    it 'adds new row to user languages for absent link' do
      expect { user.add_language create(:language) }.to change(UserLanguage, :count).by(1)
    end

    it 'does not add row to user languages for existing link' do
      expect { user.add_language user.language }.not_to change(UserLanguage, :count)
    end
  end

  describe '#remove_language' do
    let(:user) { create :user }

    before(:each) { create :user_language, user: user, language: user.language }

    it 'removes row from user languages for existing link' do
      expect { user.remove_language user.language }.to change(UserLanguage, :count).by(-1)
    end

    it 'does not change user languages for absent link' do
      expect { user.remove_language create(:language) }.not_to change(UserLanguage, :count)
    end
  end

  describe '#with_long_uid' do
    it 'returns native user' do
      user = create :user
      expect(User.with_long_uid user.long_uid).to eq(user)
    end

    it 'returns vk user' do
      user = create :user, network: User.networks[:vk], uid: '42'
      expect(User.with_long_uid user.long_uid).to eq(user)
    end

    it 'returns nil for unknown network' do
      user = create :user
      expect(User.with_long_uid "invalid-#{user.uid}").to be_nil
    end
  end
end
