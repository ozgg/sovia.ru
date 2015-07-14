require 'rails_helper'

RSpec.describe Goal, type: :model do
  it_behaves_like 'required_user'
  it_behaves_like 'has_owner'

  context 'validation' do
    it 'fails without name' do
      goal = build :goal, name: ' '
      expect(goal).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :goal).to be_valid
    end
  end
end
