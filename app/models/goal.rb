class Goal < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name

  enum status: [:issued, :achieved, :rejected]
end
