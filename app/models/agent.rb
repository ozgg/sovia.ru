class Agent < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 255

  has_many :agent_requests, dependent: :destroy

  def add_request
    self.agent_requests.create(requests_count: 1, day: DateTime.now)
  end
end
