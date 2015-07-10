class Agent < ActiveRecord::Base
  belongs_to :browser, counter_cache: true

  has_many :users, dependent: :nullify
  has_many :posts, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name
end
