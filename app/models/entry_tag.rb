class EntryTag < ActiveRecord::Base
  belongs_to :entry
  belongs_to :tag
  validates_uniqueness_of :entry_id, scope: :tag_id
  after_create :increment_entries_count
  before_destroy :decrement_entries_count

  def self.find_for_pair(entry, tag)
    find_by(entry: entry, tag: tag)
  end

  private

  def increment_entries_count
    tag.increment! :entries_count
  end

  def decrement_entries_count
    tag.decrement! :entries_count
  end
end
