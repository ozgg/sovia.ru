require 'rails_helper'

RSpec.describe ApplicationController, type: :controller, wip: true do
  let!(:agent) { create :agent }

  describe '#track_agent' do
    before(:each) { allow(controller).to receive(:agent).and_return(agent) }

    it 'calls #agent' do
      expect(controller).to receive(:agent)
      controller.send(:track_agent)
    end

    it 'calls #add_request for agent' do
      expect(agent).to receive(:add_request)
      controller.send(:track_agent)
    end
  end

  describe '#agent' do
    context 'when @agent is assigned' do
      before(:each) { controller.instance_variable_set(:@agent, agent) }

      it 'does not send for_string to Agent' do
        expect(Agent).not_to receive(:for_string)
        controller.send(:agent)
      end

      it 'returns instance of Agent' do
        returned_agent = controller.send(:agent)
        expect(returned_agent).to eq(agent)
      end
    end

    context 'when @agent is not assigned' do
      before :each do
        controller.instance_variable_set :@agent, nil
        allow(request).to receive(:user_agent).and_return(agent.name)
        allow(Agent).to receive(:for_string).and_return(agent)
      end

      it 'gets agent name from request' do
        expect(request).to receive(:user_agent)
        controller.send(:agent)
      end

      it 'calls Agent#for_string to find agent' do
        expect(Agent).to receive(:for_string)
        controller.send(:agent)
      end

      it 'assigns instance of Agent to @agent' do
        controller.send(:agent)
        expect(assigns[:agent]).to eq(agent)
      end

      it 'returns instance of Agent' do
        returned_agent = controller.send(:agent)
        expect(returned_agent).to eq(agent)
      end
    end
  end
end
