module HasOwner
  extend ActiveSupport::Concern

  def owned_by?(user)
    user.is_a?(User) && (self.user == user)
  end
end
