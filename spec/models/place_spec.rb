require 'rails_helper'

RSpec.describe Place, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_location'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Place.included_modules).to include(HasOwner)
    end
  end

  describe 'validation' do
    it 'fails without name' do
      place = build :place, name: ' '
      expect(place).not_to be_valid
    end

    it 'fails for azimuth greater than 359' do
      place = build :place, azimuth: 360
      expect(place).not_to be_valid
    end

    it 'fails for azimuth less than 0' do
      place = build :place, azimuth: -1
      expect(place).not_to be_valid
    end
  end
end
