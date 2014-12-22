class Goal < ActiveRecord::Base
  belongs_to :user

  enum status: [:issued, :achieved, :rejected]
end
