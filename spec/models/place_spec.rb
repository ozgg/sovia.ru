require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'validation' do
    it 'fails without user' do
      place = build :places, user: nil
      expect(place).not_to be_valid
    end

    it 'fails without name' do
      place = build :places, name: ' '
      expect(place).not_to be_valid
    end

    it 'fails with name longer than 255 symbols' do
      place = build :places, name: 'A' * 256
      expect(place).not_to be_valid
    end

    it 'passes for valid model' do
      expect(build :places).to be_valid
    end
  end

  describe '#editable_by?' do
    let(:places) { create :places }

    it 'returns true for place owner' do
      expect(place).to be_editable_by(place.user)
    end

    it 'returns false for anonymous user' do
      expect(place).not_to be_editable_by(nil)
    end

    it 'returns false for non-owner' do
      expect(place).not_to be_editable_by(create(:unconfirmed_user))
    end
  end
end
