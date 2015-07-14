require 'rails_helper'

RSpec.describe Code, type: :model do
  it_behaves_like 'required_user'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Code.included_modules).to include(HasOwner)
    end

    it 'includes has_trace' do
      expect(Code.included_modules).to include(HasTrace)
    end
  end

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
end
