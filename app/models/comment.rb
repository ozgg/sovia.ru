class Comment < ActiveRecord::Base
  belongs_to :entry, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: 'Comment'
  has_many :comments

  validates_presence_of :entry, :body

  def notify_entry_owner?
    if parent.nil?
      notify_owner?(entry.user)
    else
      parent_owner = parent.user
      !parent_owner.nil? && parent_owner != user
    end
  end

  def notify_parent_owner?
    if parent.nil?
      false
    else
      notify_owner?(parent.user)
    end
  end

  def parsed_body
    '<p>' + CGI::escapeHTML(body.strip).gsub(/(?:\r?\n)+/, '</p><p>') + '</p>'
  end

  private

  def notify_owner?(owner)
    !owner.nil? && owner.can_receive_letters? && owner != user
  end
end
