# frozen_string_literal: true

# Dream of user
#
# Attributes:
#   agent_id [Agent], optional
#   body [Text]
#   created_at [DateTime]
#   interpreted [Boolean]
#   ip [Inet], optional
#   lucidity [Integer]
#   needs_interpretation [Boolean]
#   privacy [Integer]
#   sleep_place_id [SleepPlace], optional
#   title [String], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   visible [Boolean]
class Dream < ApplicationRecord
  include Checkable
  include HasOwner
  include Toggleable

  BODY_LIMIT     = 65_535
  LUCIDITY_RANGE = (0..5).freeze
  TITLE_LIMIT    = 255

  toggleable :visible, :interpreted

  enum privacy: %i[generally_accessible visible_to_community visible_to_interpreter personal]

  belongs_to :user, optional: true
  belongs_to :sleep_place, optional: true
  belongs_to :agent, optional: true
  has_many :dream_patterns, dependent: :destroy
  has_many :patterns, through: :dream_patterns
  has_many :dream_words, dependent: :destroy
  has_many :words, through: :dream_words

  before_validation :normalize_title
  before_validation :normalize_lucidity
  before_validation :normalize_place
  before_validation :normalize_privacy

  scope :visible, -> { where(visible: true) }
  scope :recent, -> { order('id desc') }
  scope :with_privacy, ->(v) { where(privacy: v) }
  scope :list_for_visitors, ->(u) { visible.with_privacy(Dream.privacy_for_user(u)).recent }
  scope :list_for_administration, -> { where('privacy <= ?', Dream.privacies[:personal]).recent }

  # @param [User] user
  # @param [Integer] page
  def self.page_for_visitor(user, page = 1)
    list_for_visitors(user).page(page)
  end

  # @param [User|nil] user
  def self.privacy_for_visitor(user)
    interpreter = UserPrivilege.user_has_privilege?(user, :interpreter)
    values      = [privacies[:generally_accessible]]
    values << privacies[:visible_to_community] unless user.nil?
    values << privacies[:visible_to_interpreter] if interpreter

    values
  end

  # @param [User] user
  def self.entity_parameters(user)
    result = %i[body lucidity title]
    unless user.nil?
      result += %i[needs_interpretation sleep_place_id privacy]
    end

    result
  end

  private

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
    return unless user.nil?

    self.visibility = Dream.privacies[:generally_accessible]
  end
end
