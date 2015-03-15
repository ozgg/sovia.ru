require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#track_agent' do
    it "calls Agent#from_string with user-agent from request" do
      agent = create :agent
      allow(request).to receive(:user_agent).and_return(agent.name)
      allow(Agent).to receive(:for_string).with(agent.name).and_return(agent)
      allow(agent).to receive(:add_request)

      expect(Agent).to receive(:for_string)
      expect(request).to receive(:user_agent)
      expect(agent).to receive(:add_request)

      controller.send(:track_agent)
    end
  end
end
