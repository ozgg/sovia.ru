class Goal < ActiveRecord::Base
  include HasOwner

  belongs_to :user

  enum status: [:issued, :achieved, :rejected]

  validates_presence_of :user_id, :name
end
