class Comment < ActiveRecord::Base
  belongs_to :entry, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: 'Comment'
  has_many :comments

  validates_presence_of :entry, :body

  def notify_entry_owner?
    owner = entry.user
    if owner.nil? || owner == user
      false
    elsif parent.nil?
      notify_owner?(entry.user)
    else
      parent_owner = parent.user
      !parent_owner.nil? && parent_owner != entry.user
    end
  end

  def notify_parent_owner?
    if parent.nil?
      false
    else
      notify_owner?(parent.user)
    end
  end

  def datetime
    created_at.strftime '%Y-%m-%dT%H:%M:%S%:z'
  end

  private

  def notify_owner?(owner)
    !owner.nil? && owner.can_receive_letters? && owner != user
  end
end
