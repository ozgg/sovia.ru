require 'rails_helper'

RSpec.describe AgentRequest, type: :model do
  context "when validating" do
    it "is invalid without agent" do
      agent_request = build :agent_request, agent: nil
      expect(agent_request).not_to be_valid
    end

    it "is invalid without day" do
      agent_request = build :agent_request, day: nil
      expect(agent_request).not_to be_valid
    end

    it "is invalid without requests_count" do
      agent_request = build :agent_request, requests_count: nil
      expect(agent_request).not_to be_valid
    end

    it "has unique pair agent-day" do
      first_request = create :agent_request
      second_request = build :agent_request, agent: first_request.agent, day: first_request.day
      expect(second_request).not_to be_valid
    end

    it "is valid with valid attributes" do
      agent_request = build :agent_request
      expect(agent_request).to be_valid
    end
  end
end
