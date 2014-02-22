require 'spec_helper'

describe User do
  context "validation" do
    let(:user) { build(:user, login: 'random_guy') }

    it "is valid with default attributes" do
      expect(user).to be_valid
    end

    it 'is invalid when login does not match pattern /\A[a-z0-9_]{1,30}\z/' do
      user.login = 'bad login'
      expect(user).not_to be_valid
    end

    it "converts login to lowercase before validation" do
      user.login = 'Another_GUY'
      user.valid?
      expect(user.login).to eq('another_guy')
    end

    it "converts email to lowercase before validation" do
      user.email = 'NOREPLY@example.com'
      user.valid?
      expect(user.email).to eq('noreply@example.com')
    end

    it "has unique login" do
      user.save
      another_user = build(:user, login: 'random_guy', email: 'noreply@example.com')
      expect(another_user).not_to be_valid
    end

    it "has unique email" do
      user.email = 'noreply@example.com'
      user.save
      another_user = build(:user, email: 'noreply@example.com')
      expect(another_user).not_to be_valid
    end

    it "is invalid when email does not look like email" do
      user.email = 'www'
      expect(user).not_to be_valid
    end
  end

  context "#email_confirmation" do
    let(:user) { create(:user) }

    context "when email is not set" do
      it "returns nil" do
        user.email = nil
        expect(user.email_confirmation).to be_nil
      end
    end

    context "when mail_confirmed is true" do
      before(:each) { user.mail_confirmed = true }

      it "returns nil" do
        expect(user.email_confirmation).to be_nil
      end
    end

    context "when email_confirmed is false" do
      let(:user) { create(:unconfirmed_user) }

      it "returns existing code if it exists and isn't activated" do
        code = create(:email_confirmation, user: user)
        expect(user.email_confirmation).to eq(code)
      end

      it "returns new code if no codes exist" do
        code = user.email_confirmation
        expect(code).to be_persisted
        expect(code).to be_a(Code::Confirmation)
      end

      it "returns new code if all codes are used" do
        create(:email_confirmation, user: user, activated: true)
        code = user.email_confirmation
        expect(code).to be_persisted
        expect(code).to be_a(Code::Confirmation)
      end
    end
  end

  context "#password_recovery" do
    context "when email is not set" do
      let(:user) { create(:user) }

      it "returns nil" do
        user.email = nil
        expect(user.password_recovery).to be_nil
      end
    end

    context "when email is set" do
      let(:user) { create(:user, email: 'noreply@example.com') }

      it "returns existing code if it exists and isn't activated" do
        code = create(:password_recovery, user: user)
        expect(user.password_recovery).to eq(code)
      end

      it "returns new code if no codes exist" do
        code = user.password_recovery
        expect(code).to be_persisted
        expect(code).to be_a(Code::Recovery)
      end

      it "returns new code if all codes are used" do
        create(:password_recovery, user: user, activated: true)
        code = user.password_recovery
        expect(code).to be_persisted
        expect(code).to be_a(Code::Recovery)
      end
    end
  end
end