class Violation < ActiveRecord::Base
  include HasOwner
  include HasTrace

  belongs_to :user

  validates_presence_of :agent_id, :ip

  enum category: [:dreams_spam, :comments_spam]
end
