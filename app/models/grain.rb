class Grain < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  belongs_to :pattern
  has_many :dream_grains, dependent: :destroy
  has_many :dreams, through: :dream_grains

  enum category: [:person, :place, :item, :event, :action, :creature]

  validates_presence_of :user_id
  validates_uniqueness_of :slug, scope: [:user_id, :language_id]

  mount_uploader :image, ImageUploader

  def self.match_by_name(name, language, user)
    find_by user: user, language: language, slug: Canonizer.canonize(name)
  end

  def self.match_or_create_by_name(name, language, user)
    grain = self.match_by_name name, language, user
    grain || self.create(user: user, language: language, name: name)
  end
end
