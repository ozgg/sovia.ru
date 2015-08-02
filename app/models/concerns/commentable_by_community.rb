module CommentableByCommunity
  extend ActiveSupport::Concern

  def commentable_by?(user)
    user.is_a? User
  end
end
