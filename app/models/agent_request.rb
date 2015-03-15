class AgentRequest < ActiveRecord::Base
  belongs_to :agent

  validates_presence_of :agent, :day, :requests_count
  validates_uniqueness_of :agent_id, scope: :day
end
