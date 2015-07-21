require 'rails_helper'

RSpec.describe Code, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_owner'
  it_behaves_like 'has_trace'

  describe 'new instance' do
    it 'generates code body' do
      expect(Code.new.body).not_to be_nil
    end
  end

  describe 'validation' do
    it 'fails without body' do
      code = build :code
      code.body = ' '
      expect(code).not_to be_valid
    end

    it 'fails for non-unique body' do
      code = create :code
      another_code = build :code
      another_code.body = code.body
      expect(another_code).not_to be_valid
    end
  end

  describe '#track!' do
    it 'updates ip and agent' do
      ip    = '127.0.0.1'
      agent = create :agent
      code  = create :code
      expect(code).to receive(:update!).with(ip: ip, agent: agent)
      code.track! ip, agent
    end
  end

  describe '#recovery_for_user' do
    pending
  end

  describe '#confirmation_for_user' do
    pending
  end
end
