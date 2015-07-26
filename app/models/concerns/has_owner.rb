module HasOwner
  extend ActiveSupport::Concern

  included do
    scope :owned_by, ->(user) { where user: user }
  end

  def owned_by?(user)
    user.is_a?(User) && (self.user == user)
  end
end
