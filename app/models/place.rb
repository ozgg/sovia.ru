class Place < ActiveRecord::Base
  include HasUser
  include HasLanguage
  include HasPrivacy
  include HasCoordinates
  include HeadDirection

  belongs_to :agent

  mount_uploader :image, ImageUploader

  validates_presence_of :user_id, :name
  validates_length_of :name, maximum: 255

  def editable_by?(user)
    owned_by? user
  end
end
