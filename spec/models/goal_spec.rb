require 'rails_helper'

RSpec.describe Goal, type: :model, wip: true do
  it_behaves_like 'required_user'

  context 'class definition' do
    it 'includes has_owner' do
      expect(Goal.included_modules).to include(HasOwner)
    end
  end

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
