require 'rails_helper'

RSpec.describe Token, type: :model do
  let(:model) { :token }

  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'passes with valid attributes' do
      entity = build model
      expect(entity).to be_valid
    end

    it 'fails with non-unique token' do
      existing = create model
      entity   = build model, token: existing.token
      expect(entity).not_to be_valid
    end
  end

  describe '#user_by_token' do
    let(:user) { create :user }

    it 'returns nil for empty input' do
      expect(Token.user_by_token nil).to be_nil
    end

    it 'returns nil for non-existent token' do
      expect(Token.user_by_token 'nobody').to be_nil
    end

    it 'returns nil for mismatched pair' do
      token = create model, user: user
      expect(Token.user_by_token "#{user.id}0:#{token.token}").to be_nil
    end

    it 'returns nil for inactive token' do
      token = create model, user: user, active: false
      expect(Token.user_by_token "#{user.id}:#{token.token}").to be_nil
    end

    it 'returns user for valid pair' do
      token = create model, user: user
      expect(Token.user_by_token "#{user.id}:#{token.token}").to eq(user)
    end
  end
end
