class DreamPattern < ActiveRecord::Base
  belongs_to :dream
  belongs_to :pattern

  enum status: [:by_owner, :suggested, :rejected, :forced]

  validates_presence_of :dream_id, :pattern_id
  validates_uniqueness_of :pattern_id, scope: :dream_id

  after_create :increment_dream_count
  after_destroy :decrement_dream_count

  def external?
    [:suggested, :rejected, :forced].include? self.status.to_sym
  end

  protected

  def increment_dream_count
    self.pattern.increment! :dream_count
  end

  def decrement_dream_count
    self.pattern.decrement! :dream_count
  end
end
