require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#track_agent' do
    it "calls Agent#for_string with user-agent from request" do
      agent = create :agent

      expect(Agent).to receive(:for_string).and_return(agent)
      expect(request).to receive(:user_agent).and_return(agent.name)
      expect(agent).to receive(:add_request)

      controller.send(:track_agent)
    end
  end
end
