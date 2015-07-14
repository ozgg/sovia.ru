require 'rails_helper'

RSpec.describe PatternLink, type: :model do
  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :pattern_link).to be_valid
    end

    it 'fails without pattern' do
      expect(build :pattern_link, pattern: nil).not_to be_valid
    end

    it 'fails without target' do
      expect(build :pattern_link, target: nil).not_to be_valid
    end

    it 'fails with non-unique triplet' do
      link = create :pattern_link
      expect(build :pattern_link, pattern: link.pattern, target: link.target, category: link.category).not_to be_valid
    end
  end
end
