require 'rails_helper'

RSpec.describe Token, type: :model do
  subject { build :token }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'fails with non-unique token' do
      create :token, token: subject.token
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:token)
    end
  end

  describe '::user_by_token' do
    let(:user) { create :user }

    it 'returns nil for empty input' do
      expect(Token.user_by_token nil).to be_nil
    end

    it 'returns nil for non-existent token' do
      expect(Token.user_by_token 'nobody').to be_nil
    end

    it 'returns nil for mismatched pair' do
      subject.user = user
      subject.save!
      expect(Token.user_by_token "#{user.id}0:#{subject.token}").to be_nil
    end

    it 'returns nil for inactive token' do
      subject.user = user
      subject.active = false
      subject.save!
      expect(Token.user_by_token "#{user.id}:#{subject.token}").to be_nil
    end

    it 'returns user for valid pair' do
      subject.user = user
      subject.save!
      expect(Token.user_by_token "#{user.id}:#{subject.token}").to eq(user)
    end
  end
end
