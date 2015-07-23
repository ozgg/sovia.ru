require 'rails_helper'

RSpec.describe Dream, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_azimuth'
  it_behaves_like 'has_owner'
  it_behaves_like 'has_trace'

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :dream).to be_valid
    end

    it 'fails without body' do
      dream = build :dream, body: ' '
      expect(dream).not_to be_valid
    end

    it 'fails with mood lower than -2' do
      expect(build :dream, mood: -3).not_to be_valid
    end

    it 'fails with mood greater than 2' do
      expect(build :dream, mood: 3).not_to be_valid
    end

    it 'fails with lucidity less than 0' do
      expect(build :dream, lucidity: -1).not_to be_valid
    end

    it 'fails with lucidity greater than 5' do
      expect(build :dream, lucidity: 6).not_to be_valid
    end

    it 'fails with time of day less than 0' do
      expect(build :dream, time_of_day: -1).not_to be_valid
    end

    it 'fails with time of day greater than 23' do
      expect(build :dream, time_of_day: 24).not_to be_valid
    end

    it 'fails with foreign place' do
      user  = create :user
      place = create :place
      expect(build :dream, user: user, place: place).not_to be_valid
    end
  end
end
