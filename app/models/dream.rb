# frozen_string_literal: true

# Dream of user
#
# Attributes:
#   agent_id [Agent], optional
#   body [Text]
#   created_at [DateTime]
#   interpreted [Boolean]
#   ip_address_id [IpAddress], optional
#   lucidity [Integer]
#   privacy [Integer], enum
#   simple_image_id [SimpleImage], optional
#   sleep_place_id [SleepPlace], optional
#   title [String], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [UUID]
class Dream < ApplicationRecord
  include Checkable
  include HasOwner
  include HasSimpleImage
  include HasTrack
  include HasUuid

  BODY_LIMIT = 65_535
  LUCIDITY_RANGE = (0..5)
  TITLE_LIMIT = 255

  enum privacy: %i[generally_accessible for_community personal]

  belongs_to :user, optional: true
  belongs_to :sleep_place, optional: true, counter_cache: true
  has_many :interpretations

  before_validation :normalize_attributes

  scope :recent, -> { order('id desc') }
  scope :with_privacy, ->(v) { where(privacy: v) }
  scope :list_for_visitors, ->(u) { visible.with_privacy(Dream.privacy_for_user(u)).recent }
  scope :list_for_administration, -> { where('privacy <= ?', Dream.privacies[:personal]).recent }
  scope :list_for_owner, ->(v) { owned_by(v).recent }

  # @param [User] user
  # @param [Integer] page
  def self.page_for_visitor(user, page = 1)
    list_for_visitors(user).page(page).per(18)
  end

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    list_for_owner(user).page(page).per(18)
  end

  # @param [User|nil] user
  def self.privacy_for_user(user)
    values = [privacies[:generally_accessible]]
    values << privacies[:for_community] unless user.nil?

    values
  end

  # @param [User] user
  def self.entity_parameters(user)
    result = %i[body lucidity title]
    result += %i[sleep_place_id privacy] unless user.nil?

    result
  end

  # Is dream visible to user?
  #
  # @param [User|nil] user who tries to see the dream
  def visible_to?(user)
    return true if generally_accessible? || owned_by?(user)

    for_community? && user.is_a?(User)
  end

  def title!
    title || I18n.t(:untitled)
  end

  def text_for_link
    title!
  end

  def world_url
    "/dreams/#{id}"
  end

  def suspect_spam?
    user.nil? && body.scan(%r{https?://[a-z0-9]+}i).length.positive?
  end

  private

  def normalize_attributes
    normalize_title
    normalize_lucidity
    normalize_place
    normalize_privacy
  end

  def normalize_title
    self.title = title.blank? ? nil : title[0..(TITLE_LIMIT - 1)]
  end

  def normalize_lucidity
    self.lucidity = LUCIDITY_RANGE.first if lucidity < LUCIDITY_RANGE.first
    self.lucidity = LUCIDITY_RANGE.last if lucidity > LUCIDITY_RANGE.last
  end

  def normalize_place
    return if sleep_place.nil?

    self.sleep_place = nil if user.nil? || !sleep_place.owned_by?(user)
  end

  def normalize_privacy
    self.privacy = Dream.privacies[:generally_accessible] if user.nil?
  end
end
