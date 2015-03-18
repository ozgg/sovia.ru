require 'rails_helper'

describe Code, type: :model do
  let(:code) { build(:code) }

  describe 'when validating' do
    it "is invalid without body" do
      code.body = ' '
      code.valid?
      expect(code.errors).to have_key(:body)
    end

    it "has unique body" do
      another_code = create(:email_confirmation)
      code.body = another_code.body
      expect(code).not_to be_valid
    end

    it "has non-empty body on creation" do
      expect(Code.new.body).not_to be_blank
    end
  end

  describe '#track', wip: true do
    it 'updates ip and agent' do
      ip    = '127.0.0.1'
      agent = create :agent
      code  = create :email_confirmation
      expect(code).to receive(:update).with(ip: ip, agent: agent)
      code.track ip, agent
    end
  end
end