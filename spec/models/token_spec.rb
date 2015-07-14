require 'rails_helper'

RSpec.describe Token, type: :model, wip: true do
  it_behaves_like 'required_user'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Token.included_modules).to include(HasOwner)
    end

    it 'includes has_trace' do
      expect(Token.included_modules).to include(HasTrace)
    end
  end
end
