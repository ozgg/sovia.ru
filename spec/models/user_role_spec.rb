require 'rails_helper'

RSpec.describe UserRole, type: :model do
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'fails with non-unique pair' do
      entity = create :user_role
      expect(build :user_role, user: entity.user).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :user_role).to be_valid
    end
  end

  describe '#user_has_role?' do
    let(:user) { create :user }

    before :each do
      create :user_role, user: user, role: :administrator
    end

    it 'returns true for existing pair' do
      expect(UserRole).to be_user_has_role(user, :administrator)
    end

    it 'returns false for absent pair' do
      expect(UserRole).not_to be_user_has_role(user, :moderator)
    end

    it 'returns false for unknown role' do
      expect(UserRole).not_to be_user_has_role(user, :non_existent)
    end
  end
end
