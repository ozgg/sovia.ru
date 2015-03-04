class Goal < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  has_many :deeds, dependent: :nullify

  enum status: [:issued, :achieved, :rejected]

  def self.active_goals(user)
    where(user: user).issued.order('id asc').all
  end

  def owned_by?(user)
    self.user == user
  end
end
