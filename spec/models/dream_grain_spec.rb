require 'rails_helper'

RSpec.describe DreamGrain, type: :model do
  let(:dream) { create :dream }
  let(:grain) { create :grain }

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :dream_grain).to be_valid
    end

    it 'fails without dream' do
      expect(build :dream_grain, dream: nil).not_to be_valid
    end

    it 'fails without grain' do
      expect(build :dream_grain, grain: nil).not_to be_valid
    end

    it 'fails with non-unique pair' do
      pair = create :dream_grain
      expect(build :dream_grain, dream: pair.dream, grain: pair.grain).not_to be_valid
    end
  end

  describe 'after create' do
    it 'increments dream count in grain' do
      expect { create :dream_grain, dream: dream, grain: grain }.to change(grain, :dream_count).by(1)
    end
  end

  describe 'after destroy' do
    it 'decrements dream count in pattern' do
      pair = create :dream_grain, dream: dream, grain: grain
      expect { pair.destroy }.to change(grain, :dream_count).by(-1)
    end
  end
end
