class Dream < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasTrace

  belongs_to :user
  belongs_to :place

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :dream_patterns, dependent: :destroy
  has_many :patterns, through: :dream_patterns
  has_many :dream_grains, dependent: :destroy
  has_many :grains, through: :dream_grains
  has_many :dream_factors, dependent: :destroy

  enum privacy: [:generally_accessible, :visible_to_community, :visible_to_followees, :personal]
  enum body_position: [:left, :back, :right, :stomach]

  validates :azimuth, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, allow_nil: true
  validates :mood, numericality: { greater_than_or_equal_to: -2, less_than_or_equal_to: 2 }
  validates :lucidity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :time_of_day, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }, allow_nil: true
  validates_presence_of :body
  validate :place_has_same_owner

  mount_uploader :image, ImageUploader

  protected

  def place_has_same_owner
    if place.is_a?(Place) && !place.owned_by?(self.user)
      errors.add :place_id, I18n.t('activerecord.errors.models.dream.attribute.foreign')
    end
  end
end
