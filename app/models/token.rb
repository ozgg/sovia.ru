class Token < ActiveRecord::Base
  include HasOwner
  include HasTrace

  belongs_to :user
  belongs_to :client

  has_secure_token

  validates_presence_of :user_id
  validates_uniqueness_of :token

  def self.user_by_token(token)

  end
end
