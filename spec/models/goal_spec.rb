require 'rails_helper'

RSpec.describe Goal, type: :model do
  context 'validation' do
    it 'fails without user' do
      goal = build :goal, user: nil
      expect(goal).not_to be_valid
    end

    it 'fails without name' do
      goal = build :goal, name: ' '
      expect(goal).not_to be_valid
    end

    it 'passes for valid parameters' do
      expect(build :goal).to be_valid
    end
  end
end
