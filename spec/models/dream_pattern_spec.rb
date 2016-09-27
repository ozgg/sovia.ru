require 'rails_helper'

RSpec.describe DreamPattern, type: :model do
  subject { build :dream_pattern }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_dream'

  describe 'validation' do
    it 'fails without pattern' do
      subject.pattern = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:pattern)
    end

    it 'fails with non-unique pair' do
      create :dream_pattern, dream: subject.dream, pattern: subject.pattern
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:pattern_id)
    end
  end
end
