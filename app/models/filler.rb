# frozen_string_literal: true

# Dream filler
#
# Attributes:
#   body [Text]
#   title [String], optional
#   user_id [User]
class Filler < ApplicationRecord
  include Checkable

  belongs_to :user, optional: true

  validate :user_should_be_bot
  validates_presence_of :body
  validates_length_of :body, maximum: Dream::BODY_LIMIT
  validates_length_of :title, maximum: Dream::TITLE_LIMIT

  scope :list_for_administration, -> { order('id asc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[body title user_id]
  end

  def title!
    title.blank? ? I18n.t(:untitled) : title
  end

  def text_for_link
    title!
  end

  private

  def user_should_be_bot
    return if user.nil? || user.bot?

    errors.add(:user, I18n.t('activerecord.errors.models.filler.user.not_bot'))
  end
end
