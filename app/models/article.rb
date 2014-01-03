class Article < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :title, :body

  after_create :increment_entries_counter
  after_destroy :decrement_entries_counter

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
