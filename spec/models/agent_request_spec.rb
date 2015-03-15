require 'rails_helper'

RSpec.describe AgentRequest, type: :model, wip: true do
  context "when validating" do
    it "is invalid without agent"
    it "is invalid without day"
    it "has unique pair agent-day"
    it "is valid with valid attributes"
  end
end
