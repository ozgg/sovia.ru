require 'rails_helper'

RSpec.describe Place, type: :model, wip: true do
  describe 'validation' do
    it 'fails without user' do
      place = build :place, user: nil
      expect(place).not_to be_valid
    end

    it 'fails without name' do
      place = build :place, name: ' '
      expect(place).not_to be_valid
    end

    it 'fails with name longer than 255 symbols' do
      place = build :place, name: 'A' * 256
      expect(place).not_to be_valid
    end

    it 'passes for valid model' do
      expect(build :place).to be_valid
    end
  end
end
