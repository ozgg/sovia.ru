require 'rails_helper'

RSpec.shared_examples_for 'has_trace' do
  let(:model) { described_class.to_s.underscore.to_sym }
  let(:agent) { create :agent }

  describe '#agent_name' do
    it 'returns nil when agent is nil' do
      entity = build model, agent: nil
      expect(entity.agent_name).to be_nil
    end

    it 'returns agent name when agent is present' do
      entity = build model, agent: agent
      expect(entity.agent_name).to eq(agent.name)
    end
  end

  describe '#trace_data' do
    it 'returns hash with agent name and IP address' do
      entity = build model, agent: agent, ip: '127.0.0.1'
      expect(entity.trace_data).to eq({ agent: agent.name, ip: '127.0.0.1' })
    end
  end
end
