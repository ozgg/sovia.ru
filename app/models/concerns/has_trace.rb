module HasTrace
  extend ActiveSupport::Concern

  included do
    belongs_to :agent
  end

  module ClassMethods
  end

  def agent_name
    self.agent.blank? ? nil : self.agent.name
  end

  def trace_data
    {
        agent: agent_name,
        ip: self.ip,
    }
  end
end
