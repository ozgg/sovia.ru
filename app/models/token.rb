class Token < ActiveRecord::Base
  include HasOwner
  include HasTrace

  belongs_to :user
  belongs_to :client

  has_secure_token

  validates_presence_of :user_id
  validates_uniqueness_of :token

  def self.user_by_token(input)
    unless input.blank?
      pair = input.split(':')
      self.user_by_pair pair[0], pair[1] if pair.length == 2
    end
  end

  def self.user_by_pair(user_id, token)
    instance = self.find_by user_id: user_id, token: token, active: true
    instance.is_a?(self) ? instance.user : nil
  end
end
