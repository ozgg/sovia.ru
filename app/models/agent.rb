class Agent < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 255

  has_many :agent_requests, dependent: :destroy

  # Get instance of Agent for given string
  #
  # Trims agent name upto 255 characters
  #
  # @param [String] name
  # @return [Agent]
  def self.for_string(name)
    name = name[0..254]
    agent = self.find_by_name name
    if agent.nil?
      agent = self.create name: name
    end

    agent
  end

  # Increments requests counter for this agent for today
  #
  # @return [AgentRequest]
  def add_request
    agent_request = AgentRequest.today_for_agent self
    if agent_request.nil?
      self.agent_requests.create(requests_count: 1, day: DateTime.now)
    else
      agent_request.increment! :requests_count
      agent_request
    end
  end
end
