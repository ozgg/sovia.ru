class UserRole < ActiveRecord::Base
  belongs_to :user

  enum role: [:administrator]

  validates_presence_of :user_id
  validates_uniqueness_of :role, scope: :user
end
