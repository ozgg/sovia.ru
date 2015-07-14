require 'rails_helper'

RSpec.describe Deed, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_owner'

  context 'validation' do
    it 'fails without essence' do
      deed = build :deed, essence: ' '
      expect(deed).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :deed).to be_valid
    end
  end
end
