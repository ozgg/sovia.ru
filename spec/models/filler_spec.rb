require 'rails_helper'

RSpec.describe Filler, type: :model do
  subject { build :filler }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_body'

  describe 'validation' do
    it 'passes without user' do
      subject.user = nil
      expect(subject).to be_valid
    end

    it 'passes when user is bot' do
      subject.user = create(:user, bot: true)
      expect(subject).to be_valid
    end

    it 'fails when user is not bot' do
      subject.user = create(:user)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:user)
    end
  end
end
