class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_presence_of :user, :language, :title, :body
  mount_uploader :image, ImageUploader
end
