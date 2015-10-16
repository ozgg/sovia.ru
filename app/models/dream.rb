class Dream < ActiveRecord::Base
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

  scope :recent, -> { order('id desc') }

  PER_PAGE = 10

  def self.page_for_user(current_page, current_user)
    self.visible_to_user(current_user).recent.page(current_page).per(PER_PAGE)
  end

  # Select dreams that are visible to given user
  #
  # @param [User|nil] user who selects dreams
  # @param [User|nil] owner used for "profile" and "my dreams" context
  def self.visible_to_user(user, owner = nil)
    privacy = [self.privacies[:generally_accessible]]
    privacy << self.privacies[:visible_to_community] if user.is_a? User
    privacy << self.privacies[:visible_to_followees] if owner.is_a?(User) && owner.follows?(user)
    privacy << self.privacies[:personal] if owner.is_a?(User) && (owner == user)
    self.where privacy: privacy
  end

  def self.get_if_visible(id, current_user)
    found_dream = self.find_by id: id
    if found_dream.is_a?(Dream) && found_dream.visible_to?(current_user)
      found_dream
    end
  end

  # Parameters for controller that are available for every user
  def self.parameters_for_all
    [:title, :body, :needs_interpretation]
  end

  # Parameters for controller that are available only for logged in users
  def self.parameters_for_users
    [:place_id, :privacy, :lucidity, :mood, :azimuth, :body_position, :time_of_day, :show_image, :image]
  end

  # Parameters for controller that are available only for administrators
  def self.parameters_for_administrators
    [:interpretation_given]
  end

  def title_for_view
    result = self.title.to_s.squish
    result.blank? ? I18n.t(:untitled) : result
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

  # Add grains and patterns listed in comma-separated grains string
  #
  # @param [String] grains_string
  def grains_string=(grains_string)
    self.grains = Grain.string_to_array grains_string, self.user
    update_patterns
  end

  # Cache visible patterns in patterns_cache
  def cache_patterns!
    update patterns_cache: visible_patterns.order('slug asc').map { |pattern| pattern.name }
  end

  def lucid?
    lucidity > 0
  end

  def count_passages
    body.strip.gsub(/(\r?\n)+/, "\n").count("\n") + 1
  end

  protected

  # Place should have the same owner as dream
  def place_has_same_owner
    if place.is_a?(Place) && !place.owned_by?(self.user)
      errors.add :place_id, I18n.t('activerecord.errors.models.dream.attribute.foreign')
    end
  end

  # Anonymous users can add only generally accessible dreams
  def privacy_consistence
    if self.user.nil? && !self.generally_accessible?
      errors.add :privacy, I18n.t('activerecord.errors.models.dream.privacy.invalid')
    end
  end

  # Get visible patterns
  def visible_patterns
    Pattern.where(id: DreamPattern.visible.where(dream: self).pluck(:pattern_id))
  end

  # Update dream patterns based on given grains and external (suggested, rejected of forced) patterns
  def update_patterns
    old_links = self.dream_patterns.map { |link| [link.pattern_id, link] }.to_h
    new_links = gather_links old_links, self.grains.pluck(:pattern_id)

    self.dream_patterns = (new_links + old_links.values.select { |link| link.external? }).uniq
  end

  # Gather new pattern links set by owner
  #
  # @param [Hash] old_links
  # @param [Array] pattern_ids
  # @return [Array<DreamPattern>]
  def gather_links(old_links, pattern_ids)
    links = pattern_ids.map { |pattern_id| link_by_owner(old_links, pattern_id) }
    links.select { |link| !link.pattern_id.blank? }
  end

  # Get dream pattern that was set by owner with grain
  #
  # Forced patterns stay forced so owner cannot remove them later (add and then remove grain linked to forced pattern)
  #
  # @param [Hash] old_links
  # @param [Integer] pattern_id
  # @return DreamPattern
  def link_by_owner(old_links, pattern_id)
    link = old_links[pattern_id] || DreamPattern.new(dream: self, pattern_id: pattern_id)

    link.status = DreamPattern.statuses[:by_owner] unless link.forced?
    link.save
    link
  end
end
