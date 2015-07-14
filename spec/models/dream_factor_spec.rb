require 'rails_helper'

RSpec.describe DreamFactor, type: :model do
  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :dream_factor).to be_valid
    end

    it 'fails without dream' do
      expect(build :dream_factor, dream: nil).not_to be_valid
    end

    it 'fails with non-unique pair' do
      pair = create :dream_factor
      expect(build :dream_factor, dream: pair.dream, factor: pair.factor).not_to be_valid
    end
  end
end
