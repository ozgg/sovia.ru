require 'rails_helper'

RSpec.describe Place, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_location'
  it_behaves_like 'has_azimuth'
  it_behaves_like 'has_owner'

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
