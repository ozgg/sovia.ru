class EntryTag < ActiveRecord::Base
  belongs_to :entry
  belongs_to :tag
  validates_uniqueness_of :post_id, scope: :entry_tag_id
  after_create :increment_dreams_count
  before_destroy :decrement_dreams_count

  def self.find_for_pair(post, tag)
    where(post: post, entry_tag: tag).first
  end

  private

  def increment_dreams_count
    entry_tag.increment! :dreams_count if post.dream?
  end

  def decrement_dreams_count
    entry_tag.decrement! :dreams_count if post.dream?
  end
end
