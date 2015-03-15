class AgentRequest < ActiveRecord::Base
  belongs_to :agent

  validates_presence_of :agent, :day, :requests_count
  validates_uniqueness_of :agent_id, scope: :day

  # Get requests for given agent for today
  #
  # @param [Agent] agent
  def self.today_for_agent(agent)
    self.find_by agent: agent, day: DateTime.now.to_date
  end
end
