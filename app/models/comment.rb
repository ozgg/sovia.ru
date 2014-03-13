class Comment < ActiveRecord::Base
  belongs_to :entry, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: 'Comment'
  has_many :comments

  validates_presence_of :entry, :body

  def notify_entry_owner?
    owner = entry.user
    !owner.nil? && owner.can_receive_letters? && owner != user
  end

  def parsed_body
    '<p>' + CGI::escapeHTML(body.strip).gsub(/(?:\r?\n)+/, '</p><p>') + '</p>'
  end
end
