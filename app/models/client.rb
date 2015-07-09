class Client < ActiveRecord::Base
  validates_presence_of :name, :secret
  validates_uniqueness_of :name
end
