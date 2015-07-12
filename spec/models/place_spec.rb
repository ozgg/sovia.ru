require 'rails_helper'

RSpec.describe Place, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_location'
  it_behaves_like 'has_azimuth'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Place.included_modules).to include(HasOwner)
    end
  end

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :place).to be_valid
    end

    it 'fails without name' do
      place = build :place, name: ' '
      expect(place).not_to be_valid
    end
  end
end
