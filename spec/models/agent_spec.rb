require 'rails_helper'

RSpec.describe Agent, type: :model do
  context "when validating" do
    it "is invalid without name" do
      agent = build :agent, name: ''
      expect(agent).not_to be_valid
    end

    it "is invalid with name longer than 255 symbols" do
      name = 'A'
      255.times { name += 'a' }
      agent = build :agent, name: name
      expect(agent).not_to be_valid
    end

    it "is invalid with non-unique name" do
      first_agent = create :agent
      agent = build :agent, name: first_agent.name
      expect(agent).not_to be_valid
    end

    it "is valid with given name" do
      agent = build :agent
      expect(agent).to be_valid
    end
  end

  context "#add_request", wip: true do
    let(:agent) { create :agent }

    it "creates new record with 1 request for new date" do
      agent_request = agent.add_request
      expect(agent_request).to be_an(AgentRequest)
      expect(agent_request).to be_persisted
      expect(agent_request.requests_count).to eq(1)
      expect(agent_request.day).to eq(DateTime.now.to_date)
    end

    it "increments requests_count for existing date" do
      pending 'waiting for agent_request#today_for_agent'
      existing_request = create :agent_request, agent: agent
      requests_before  = existing_request.requests_count
      agent_request = agent.add_request
      existing_request.reload
      expect(agent_request).to eq(existing_request)
      requests_after = existing_request.requests_count
      expect(requests_after - requests_before).to eq(1)
    end
  end
end
