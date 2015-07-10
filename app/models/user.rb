class User < ActiveRecord::Base
  belongs_to :language
  belongs_to :agent
  has_secure_password
end
