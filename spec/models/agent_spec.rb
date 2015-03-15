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
    pending
  end
end
