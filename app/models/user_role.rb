class UserRole < ActiveRecord::Base
  belongs_to :user

  enum role: [:administrator, :moderator]

  validates_presence_of :user_id
  validates_uniqueness_of :role, scope: [:user_id]

  scope :for_user, ->(user) { where user: user }

  # @param [User] user
  # @param [Symbol] role
  def self.user_has_role?(user, role)
    if self.role_exists? role
      self.where(user: user, role: self.roles[role]).count == 1
    else
      false
    end
  end

  # @param [Symbol] role
  def self.role_exists?(role)
    self.roles.has_key? role
  end
end
