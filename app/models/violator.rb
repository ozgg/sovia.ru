class Violator < ActiveRecord::Base
  belongs_to :agent

  def agent_name
    agent.blank? ? 'n/a' : agent.name
  end
end
