class Dream < ActiveRecord::Base
  PRIVACY_NONE  = 0
  PRIVACY_USERS = 1
  PRIVACY_OWNER = 255

  belongs_to :user

  validates_presence_of :body
  validates_inclusion_of :privacy, in: [PRIVACY_NONE, PRIVACY_USERS, PRIVACY_OWNER]

  after_create :increment_entries_counter
  after_destroy :decrement_entries_counter

  def open?
    privacy == PRIVACY_NONE
  end

  def users_only?
    privacy == PRIVACY_USERS
  end

  def owner_only?
    privacy == PRIVACY_OWNER
  end

  private

  def increment_entries_counter
    unless user.nil?
      user.increment! :entries_count
    end
  end

  def decrement_entries_counter
    unless user.nil?
      user.decrement! :entries_count
    end
  end
end
