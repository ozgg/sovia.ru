require 'rails_helper'

RSpec.describe UserRole, type: :model do
  subject { build :user_role }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'fails without role' do
      subject.role = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:role)
    end

    it 'fails with non-unique pair' do
      create :user_role, user: subject.user, role: subject.role
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:role)
    end
  end

  describe '::user_has_role?' do
    let!(:user) { subject.user }

    before :each do
      subject.save!
    end

    it 'returns true for pair with valid role in set' do
      expect(UserRole.user_has_role?(user, :moderator, :administrator)).to be
    end

    it 'returns true for existing pair' do
      expect(UserRole.user_has_role?(user, :administrator)).to be
    end

    it 'returns false for absent pair' do
      expect(UserRole.user_has_role?(user, :moderator)).not_to be
    end

    it 'returns false for unknown role' do
      expect(UserRole.user_has_role?(user, :non_existent)).not_to be
    end
  end
end
