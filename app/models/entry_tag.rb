class EntryTag < ActiveRecord::Base
  belongs_to :entry
  belongs_to :tag
  validates_uniqueness_of :entry_id, scope: :tag_id
  after_create :increment_dreams_count
  before_destroy :decrement_dreams_count

  def self.find_for_pair(entry, tag)
    find_by(entry: entry, tag: tag)
  end

  private

  def increment_dreams_count
    tag.increment! :dreams_count if entry.dream?
  end

  def decrement_dreams_count
    tag.decrement! :dreams_count if entry.dream?
  end
end
