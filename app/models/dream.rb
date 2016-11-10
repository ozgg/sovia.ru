class Dream < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE       = 10
  LUCIDITY_RANGE = (0..5)
  MOOD_RANGE     = (-2..2)
  LINK_PATTERN   = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/
  NAME_PATTERN   = /\{(?<name>[^}]{1,30})\}(?:\((?<text>[^)]{1,30})\))?/

  METRIC_COUNT = 'dreams.count'

  toggleable :needs_interpretation, :interpretation_given

  belongs_to :agent, optional: true
  belongs_to :user, optional: true, counter_cache: true
  belongs_to :place, optional: true, counter_cache: true
  has_many :dream_patterns, dependent: :destroy
  has_many :patterns, through: :dream_patterns
  has_many :dream_words, dependent: :destroy
  has_many :words, through: :dream_words
  has_many :comments, as: :commentable

  mount_uploader :image, DreamImageUploader

  enum privacy: [:generally_accessible, :visible_to_community, :visible_to_followees, :personal]

  after_initialize :set_uuid
  before_validation :normalize_title

  validates_presence_of :body
  validates_inclusion_of :mood, in: MOOD_RANGE
  validates_inclusion_of :lucidity, in: LUCIDITY_RANGE
  validate :place_has_same_owner
  validate :privacy_consistence

  scope :not_deleted, -> { where deleted: false }
  scope :with_privacy, -> (value) { where privacy: value unless value.blank? }
  scope :public_entries, -> { where privacy: Dream.privacies[:generally_accessible] }
  scope :recent, -> { order 'id desc' }
  scope :tagged, -> (tag) { joins(:dream_patterns).where(dream_patterns: { pattern: tag }) }
  scope :archive, -> (year, month) { where "date_trunc('month', created_at) = ?", '%04d-%02d-01' % [year, month] }

  # @param [Integer] page
  def self.page_for_administration(page)
    not_deleted.with_privacy(Dream.community_privacies).recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_visitors(user, page)
    not_deleted.with_privacy(Dream.privacy_for_user(user)).recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page)
    owned_by(user).not_deleted.recent.page(page).per(PER_PAGE)
  end

  def self.community_privacies
    [Dream.privacies[:generally_accessible], Dream.privacies[:visible_to_community]]
  end

  # @params [User] user
  def self.creation_parameters(user)
    result = %i(title body)
    result += %i(place_id privacy mood lucidity image) if user.is_a? User
    result
  end

  # @params [Boolean] owner
  def self.entity_parameters(owner)
    result = %i(title body)
    result += %i(place_id privacy mood lucidity image) if owner
    result
  end

  # @param [User] user
  def self.privacy_for_user(user)
    user.is_a?(User) ? Dream.community_privacies : Dream.privacies[:generally_accessible]
  end

  def self.random_dream
    max_offset = public_entries.count - 1
    offset     = (Time.now.to_f * 1000).to_i % max_offset
    public_entries.offset(offset).first
  end

  # Is dream visible to user?
  #
  # @param [User|nil] user who tries to see the dream
  # @return [Boolean]
  def visible_to?(user)
    method = "#{self.privacy}_to?".to_sym
    respond_to?(method) ? send(method, user) : owned_by?(user)
  end

  # Is dream visible to user as generally accessible dream?
  #
  # @param [User|nil] user who tries to see the dream
  # @return [Boolean]
  def generally_accessible_to?(user)
    user.nil? || user.is_a?(User)
  end

  # Is dream visible to user as dream for community?
  #
  # @param [User|nil] user who tries to see the dream
  # @return [Boolean]
  def visible_to_community_to?(user)
    user.is_a? User
  end

  # Is dream visible to user as dream for followees?
  #
  # @param [User|nil] user who tries to see the dream
  # @return [Boolean]
  def visible_to_followees_to?(user)
    owned_by?(user) || (self.user.is_a?(User) && self.user.follows?(user))
  end

  def editable_by?(user)
    owned_by?(user) || (UserRole.user_has_role?(user, :administrator) && visible_to?(user))
  end

  private

  def normalize_title
    if title.blank?
      self.title, self.slug = nil, nil
    else
      self.title = title.strip[0..200]
      self.slug  = Canonizer.transliterate title
    end
  end

  # Place should have the same owner as dream
  def place_has_same_owner
    if place.is_a?(Place) && !place.owned_by?(user)
      errors.add :place_id, I18n.t('activerecord.errors.models.dream.place_id.foreign')
    end
  end

  # Anonymous users can add only generally accessible dreams
  def privacy_consistence
    if user.nil? && !generally_accessible?
      errors.add :privacy, I18n.t('activerecord.errors.models.dream.privacy.invalid')
    end
  end

  def set_uuid
    if uuid.nil?
      self.uuid = SecureRandom.uuid
    end
  end
end
