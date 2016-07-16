require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  it_behaves_like 'has_valid_factory'

  describe 'before validating' do
    it 'normalizes screen name for native account' do
      subject.network     = User.networks[:native]
      subject.screen_name = 'USER_1'
      subject.valid?
      expect(subject.slug).to eq('user_1')
    end

    it 'leaves non-native slug intact' do
      subject.network     = User.networks[:vkontakte]
      subject.screen_name = 'Maxim_KM'
      subject.slug        = '1234'
      subject.valid?
      expect(subject.slug).to eq('1234')
    end
  end

  describe 'validating' do
    it 'fails without slug' do
      subject.network = :vkontakte
      subject.slug    = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with unreasonable email' do
      subject.email = 'invalid'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:email)
    end

    it 'fails with malformed native slug' do
      subject.slug        = 'invalid slug'
      subject.screen_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with non-unique slug for network' do
      create :user, screen_name: subject.screen_name.upcase
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'passes with non-unique slug for different networks' do
      create :user, slug: subject.slug, network: :vkontakte
      expect(subject).to be_valid
    end
  end

  describe '#has_role?' do
    it 'calls UserRole#user_has_role? for user and role' do
      subject.save!
      expect(UserRole).to receive(:user_has_role?).with(subject, :role)
      subject.has_role? :role
    end
  end

  describe '#add_role' do
    before :each do
      subject.save!
    end

    it 'inserts row into entity_roles for absent pair' do
      expect { subject.add_role :administrator }.to change(UserRole, :count).by(1)
    end

    it 'leaves table intact for existing pair' do
      create :user_role, user: subject, role: :administrator
      expect { subject.add_role :administrator }.not_to change(UserRole, :count)
    end

    it 'leaves table intact for non-existing role' do
      expect { subject.add_role :non_existent }.not_to change(UserRole, :count)
    end
  end

  describe '#remove_role' do
    before :each do
      subject.save!
      create :user_role, user: subject, role: :administrator
    end

    it 'removes row from user_role for existing pair' do
      expect { subject.remove_role :administrator }.to change(UserRole, :count).by(-1)
    end

    it 'leaves table intact for absent pair' do
      expect { subject.remove_role :moderator }.not_to change(UserRole, :count)
    end

    it 'leaves table intact for invalid role' do
      expect { subject.remove_role :non_existent }.not_to change(UserRole, :count)
    end
  end

  describe '#with_long_slug' do
    it 'returns native user' do
      subject.save!
      expect(User.with_long_slug subject.long_slug).to eq(subject)
    end

    it 'returns vk user' do
      subject.network = User.networks[:vkontakte]
      subject.slug = '42'
      subject.save!
      expect(User.with_long_slug subject.long_slug).to eq(subject)
    end

    it 'returns nil for unknown network' do
      subject.save!
      expect(User.with_long_slug "invalid-#{subject.slug}").to be_nil
    end
  end

  describe '#can_receive_letters?' do
    it 'returns false for users without email' do
      expect(subject.can_receive_letters?).not_to be
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
