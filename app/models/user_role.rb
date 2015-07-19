class UserRole < ActiveRecord::Base
  belongs_to :user

  enum role: [:administrator, :moderator]

  validates_presence_of :user_id
  validates_uniqueness_of :role, scope: :user

  def self.user_has_role?(user, role)
    if self.roles.has_key? role
      self.where(user: user, role: self.roles[role]).count == 1
    else
      false
    end
  end
end
