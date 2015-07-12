class DreamGrain < ActiveRecord::Base
  belongs_to :dream
  belongs_to :grain

  validates_presence_of :dream_id, :grain_id
  validates_uniqueness_of :grain_id, scope: :dream_id

  after_create :increment_dream_count
  after_destroy :decrement_dream_count

  protected

  def increment_dream_count
    self.grain.increment! :dream_count
  end

  def decrement_dream_count
    self.grain.decrement! :dream_count
  end
end
