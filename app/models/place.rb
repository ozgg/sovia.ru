class Place < ActiveRecord::Base
  include HasOwner
  include HasLocation

  belongs_to :user

  validates_presence_of :user_id, :name
  validates :azimuth, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, allow_nil: true
end
