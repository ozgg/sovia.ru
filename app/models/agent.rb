class Agent < ActiveRecord::Base
  belongs_to :browser, counter_cache: true

  validates_presence_of :name
  validates_uniqueness_of :name
end
