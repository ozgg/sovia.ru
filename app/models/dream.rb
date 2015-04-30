class Dream < ActiveRecord::Base
  belongs_to :user
  belongs_to :agent
end
