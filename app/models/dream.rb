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
  validate :privacy_consistence

  mount_uploader :image, ImageUploader

  def self.visible_to_user(user, owner = nil)
    privacy = [self.privacies[:generally_accessible]]
    privacy << self.privacies[:visible_to_community] if user.is_a? User
    privacy << self.privacies[:visible_to_followees] if owner.is_a?(User) && owner.follows?(user)
    privacy << self.privacies[:personal] if owner.is_a?(User) && (owner == user)
    self.where privacy: privacy
  end

  def self.parameters_for_all
    [:title, :body, :needs_interpretation]
  end

  def self.parameters_for_users
    [:place_id, :privacy, :lucidity, :mood, :azimuth, :body_position, :time_of_day, :show_image, :image]
  end

  def self.parameters_for_administrators
    [:interpretation_given]
  end

  def visible_to?(user)
    method = "#{self.privacy}_to?".to_sym
    respond_to?(method) ? send(method, user) : owned_by?(user)
  end

  def generally_accessible_to?(user)
    user.nil? || user.is_a?(User)
  end

  def visible_to_community_to?(user)
    user.is_a? User
  end

  def visible_to_followees_to?(user)
    owned_by?(user) || (self.user.is_a?(User) && self.user.follows?(user))
  end

  def grains_string=(grains_string)
    self.grains = Grain.string_to_array grains_string, self.language, self.user
    update_patterns
  end

  def cache_patterns!
    update patterns_cache: patterns.order('slug asc').map { |pattern| pattern.name }
  end

  protected

  def place_has_same_owner
    if place.is_a?(Place) && !place.owned_by?(self.user)
      errors.add :place_id, I18n.t('activerecord.errors.models.dream.attribute.foreign')
    end
  end

  def privacy_consistence
    if self.user.nil? && !self.generally_accessible?
      errors.add :privacy, I18n.t('activerecord.errors.models.dream.privacy.invalid')
    end
  end

  def update_patterns
    links = []
    old_patterns = self.dream_patterns.map { |link| [link.pattern_id, link] }.to_h
    self.grains.pluck(:pattern_id).each do |pattern_id|
      if old_patterns.has_key? pattern_id
        link = old_patterns[pattern_id]
        link.update status: DreamPattern.statuses[:by_owner]
      else
        link = DreamPattern.create dream: self, pattern_id: pattern_id, status: DreamPattern.statuses[:by_owner]
      end
      links << link
    end
    old_patterns.values.each do |link|
      links << link if link.external?
    end
    self.dream_patterns = links
  end
end
