class PostTag < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag

  validates_presence_of :post_id, :tag_id
  validates_uniqueness_of :tag_id, scope: :post_id

  after_create :increment_post_count
  after_destroy :decrement_post_count

  protected

  def increment_post_count
    self.tag.increment! :post_count
  end

  def decrement_post_count
    self.tag.decrement! :post_count
  end
end
