class Comment < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasTrace

  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: Comment.to_s
  belongs_to :commentable, polymorphic: true, counter_cache: true

  validates_presence_of :commentable, :body
  validate :parent_matches
  validate :commentable_is_visible
  validate :commentable_is_commentable

  def notify_entry_owner?
    if parent.is_a?(Comment) && commentable.owned_by?(parent.user)
      false
    else
      notify_user? self.commentable.user
    end
  end

  def notify_parent_owner?
    if parent.is_a? Comment
      owned_by?(parent.user) ? false : notify_user?(parent.user)
    else
      false
    end
  end

  protected

  def parent_matches
    parent = self.parent_id.blank? ? nil : Comment.find_by(id: self.parent_id)
    if parent.is_a?(Comment) && parent.commentable != self.commentable
      errors.add(:parent_id, I18n.t('activerecord.errors.models.comment.attributes.parent_id.invalid'))
    end
  end

  def commentable_is_visible
    if self.commentable.respond_to? :visible_to?
      unless self.commentable.visible_to? self.user
        errors.add(:commentable, I18n.t('activerecord.errors.models.comment.attributes.commentable.invisible'))
      end
    end
  end

  def commentable_is_commentable
    if self.commentable.respond_to? :commentable_by?
      unless self.commentable.commentable_by? self.user
        errors.add(:commentable, I18n.t('activerecord.errors.models.comment.attributes.commentable.not_commentable'))
      end
    end
  end

  def notify_user?(user)
    if user.is_a?(User) && !owned_by?(user)
      user.can_receive_letters?
    else
      false
    end
  end
end
