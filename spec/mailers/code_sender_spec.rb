require "spec_helper"

describe CodeSender do
  describe "email" do
    let(:mail) { CodeSender.email }

    it "renders the headers" do
      mail.subject.should eq("Email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "password" do
    let(:mail) { CodeSender.password }

    it "renders the headers" do
      mail.subject.should eq("Password")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
