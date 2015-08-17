class DreamPattern < ActiveRecord::Base
  belongs_to :dream
  belongs_to :pattern

  enum status: [:by_owner, :suggested, :rejected, :forced]

  validates_presence_of :dream_id, :pattern_id
  validates_uniqueness_of :pattern_id, scope: :dream_id

  after_create :increment_dream_count
  after_destroy :decrement_dream_count

  scope :visible, -> { where status: DreamPattern.visible_statuses }

  # Visible statuses for scopes
  #
  # @return [Array]
  def self.visible_statuses
    [statuses[:by_owner], statuses[:suggested], statuses[:forced]]
  end

  # Is link set externally?
  #
  # @return [Boolean]
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
