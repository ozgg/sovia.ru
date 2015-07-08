class Browser < ActiveRecord::Base
  has_many :agents, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name
end
