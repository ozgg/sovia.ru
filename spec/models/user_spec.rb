require 'rails_helper'

RSpec.describe User, type: :model do
  let(:model) { :user }

  describe 'before validating' do
    it 'normalizes screen name for native account' do
      entity = User.new network: :native, screen_name: 'USER_1'
      entity.valid?
      expect(entity.slug).to eq('user_1')
    end

    it 'leaves non-native slug intact' do
      entity = User.new network: :vkontakte, screen_name: 'Maxim_KM', slug: '1234'
      entity.valid?
      expect(entity.slug).to eq('1234')
    end
  end

  describe 'validating' do
    it 'fails without slug' do
      entity = build model, network: :vkontakte, slug: ' '
      expect(entity).not_to be_valid
    end

    it 'fails with unreasonable email' do
      entity = build model, email: 'invalid'
      expect(entity).not_to be_valid
    end

    it 'fails with malformed native slug' do
      entity = build model, slug: 'invalid slug', screen_name: nil
      expect(entity).not_to be_valid
    end

    it 'fails with non-unique slug for network' do
      entity = create model
      expect(build model, screen_name: entity.screen_name.upcase).not_to be_valid
    end

    it 'passes with non-unique slug for different networks' do
      entity = create model
      expect(build model, slug: entity.slug, network: :vkontakte).to be_valid
    end

    it 'passes with valid attributes' do
      expect(build model).to be_valid
    end
  end

  describe '#has_role?' do
    it 'calls UserRole#user_has_role? for user and role' do
      entity = create model
      expect(UserRole).to receive(:user_has_role?).with(entity, :role)
      entity.has_role? :role
    end
  end

  describe '#add_role' do
    let(:entity) { create model }

    it 'inserts row into entity_roles for absent pair' do
      expect { entity.add_role :administrator }.to change(UserRole, :count).by(1)
    end

    it 'leaves table intact for existing pair' do
      create :user_role, user: entity, role: :administrator
      expect { entity.add_role :administrator }.not_to change(UserRole, :count)
    end

    it 'leaves table intact for non-existing role' do
      expect { entity.add_role :non_existent }.not_to change(UserRole, :count)
    end
  end

  describe '#remove_role' do
    let(:entity) { create model }

    before :each do
      create :user_role, user: entity, role: :administrator
    end

    it 'removes row from user_role for existing pair' do
      expect { entity.remove_role :administrator }.to change(UserRole, :count).by(-1)
    end

    it 'leaves table intact for absent pair' do
      expect { entity.remove_role :moderator }.not_to change(UserRole, :count)
    end

    it 'leaves table intact for invalid role' do
      expect { entity.remove_role :non_existent }.not_to change(UserRole, :count)
    end
  end

  describe '#with_long_slug' do
    it 'returns native user' do
      entity = create model
      expect(User.with_long_slug entity.long_slug).to eq(entity)
    end

    it 'returns vk user' do
      entity = create model, network: User.networks[:vkontakte], slug: '42'
      expect(User.with_long_slug entity.long_slug).to eq(entity)
    end

    it 'returns nil for unknown network' do
      entity = create model
      expect(User.with_long_slug "invalid-#{entity.slug}").to be_nil
    end
  end

  describe '#can_receive_letters?' do
    it 'returns false for users without email' do
      entity = create model
      expect(entity.can_receive_letters?).not_to be
    end

    it 'returns false for users without "allow mail" flag' do
      entity = create :confirmed_user, allow_mail: false
      expect(entity.can_receive_letters?).not_to be
    end

    it 'returns true for users with confirmed email and "allow mail" flag' do
      entity = create :confirmed_user, allow_mail: true
      expect(entity.can_receive_letters?).to be
    end
  end
end
