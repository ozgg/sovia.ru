require 'rails_helper'

RSpec.describe DreamGrain, type: :model do
  subject { build :dream_grain }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_dream'

  describe 'validation' do
    it 'fails without grain' do
      subject.grain = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:grain)
    end

    it 'fails with non-unique pair' do
      create :dream_grain, dream: subject.dream, grain: subject.grain
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:grain_id)
    end

    it 'fails with foreign grain' do
      subject.grain = create :grain
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:grain)
    end
  end
end
