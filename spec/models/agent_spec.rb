require 'rails_helper'

RSpec.describe Agent, type: :model do
  describe 'Validation' do
    it 'fails without name' do
      agent = build :agent, name: ' '
      expect(agent).not_to be_valid
    end

    it 'fails with non-unique name' do
      agent = create :agent
      expect(build :agent, name: agent.name).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(Agent.new name: 'Crawler/1.0').to be_valid
    end
  end
end
