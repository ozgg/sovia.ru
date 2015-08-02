class Comment < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasTrace

  belongs_to :user, counter_cache: true
  belongs_to :commentable, polymorphic: true, counter_cache: true

  validates_presence_of :commentable, :body
  validate :parent_matches
  validate :commentable_is_visible

  protected

  def parent_matches
    unless self.parent_id.blank?
      parent = find_by! parent_id: self.parent_id
      unless parent.commentable != self.commentable
        errors.add(:parent_id, I18n.t('activerecord.errors.models.comment.attributes.parent_id.invalid'))
      end
    end
  end

  def commentable_is_visible
    if self.commentable.respond_to? :visible_to?
      unless self.commentable.visible_to? self.user
        errors.add(:commentable, I18n.t('activerecord.errors.models.comment.attributes.commentable.invisible'))
      end
    end
  end
end
