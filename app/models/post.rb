class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_presence_of :user, :language, :title, :body
  mount_uploader :image, ImageUploader

  def editable_by?(user)
    user.is_a?(User) && (self.user == user || user.has_role?(:posts_manager))
  end

  def author_name
    user.login
  end

  def preview
    lead || first_passage
  end

  def first_passage
    body.split("\n").first
  end
end
