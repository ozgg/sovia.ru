require 'rails_helper'

RSpec.describe Filler, type: :model do
  describe 'validation' do
    it 'passes with valid attributes' do
      filler = build :filler
      expect(filler).to be_valid
    end

    it 'fails without body' do
      filler = build :filler, body: ' '
      expect(filler).not_to be_valid
    end
  end
end
