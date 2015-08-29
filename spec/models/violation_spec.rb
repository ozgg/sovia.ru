require 'rails_helper'

RSpec.describe Violation, type: :model do
  describe 'validation' do
    it 'fails without agent' do
      expect(build :violation, agent: nil).not_to be_valid
    end

    it 'fails without ip' do
      expect(build :violation, ip: nil).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :violation).to be_valid
    end
  end
end
