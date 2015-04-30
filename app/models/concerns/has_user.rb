module HasUser
  extend ActiveSupport::Concern

  included do
    belongs_to :user, counter_cache: true
  end

  def owned_by?(user)
    user.is_a?(User) && (self.user == user)
  end
end
