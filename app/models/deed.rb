class Deed < ActiveRecord::Base
  include HasOwner

  belongs_to :user
  belongs_to :goal

  validates_presence_of :user_id, :essence
end
