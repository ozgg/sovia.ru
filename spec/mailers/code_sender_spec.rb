require "spec_helper"

describe CodeSender do
  describe "email" do
    let(:mail) { CodeSender.email }

    it "renders the headers" do
      mail.subject.should eq("Email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["support@sovia.ru"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "password" do
    let(:code) { create(:password_recovery, user: create(:confirmed_user)) }
    let(:mail) { CodeSender.password(code) }

    it "renders the headers" do
      mail.subject.should eq(I18n.t('code_sender.password.subject'))
      mail.to.should eq([code.user.email])
      mail.from.should eq(['support@sovia.ru'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(code.body)
    end
  end
end
