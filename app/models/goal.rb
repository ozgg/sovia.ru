class Goal < ActiveRecord::Base
  include HasOwner

  belongs_to :user
  has_many :deeds

  enum status: [:issued, :achieved, :rejected]

  validates_presence_of :user_id, :name
end
