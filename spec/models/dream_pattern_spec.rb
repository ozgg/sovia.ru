require 'rails_helper'

RSpec.describe DreamPattern, type: :model do
  let(:dream) { create :dream }
  let(:pattern) { create :pattern }

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :dream_pattern).to be_valid
    end

    it 'fails without dream' do
      pair = build :dream_pattern, dream: nil
      expect(pair).not_to be_valid
    end

    it 'fails without pattern' do
      pair = build :dream_pattern, pattern: nil
      expect(pair).not_to be_valid
    end

    it 'fails with non-unique pair' do
      pair = create :dream_pattern
      expect(build :dream_pattern, dream: pair.dream, pattern: pair.pattern).not_to be_valid
    end
  end

  describe 'after create' do
    it 'increments dream count in pattern' do
      expect { create :dream_pattern, dream: dream, pattern: pattern }.to change(pattern, :dream_count).by(1)
    end
  end

  describe 'after destroy' do
    it 'decrements dream count in pattern' do
      pair = create :dream_pattern, dream: dream, pattern: pattern
      expect { pair.destroy }.to change(pattern, :dream_count).by(-1)
    end
  end
end
