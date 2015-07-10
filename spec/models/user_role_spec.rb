require 'rails_helper'

RSpec.describe UserRole, type: :model do
  context 'validation' do
    it 'fails without user' do
      role = build :user_role, user: nil
      expect(role).not_to be_valid
    end

    it 'fails with non-unique pair' do
      role = create :user_role
      expect(build :user_role, user: role.user).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :user_role).to be_valid
    end
  end
end
