class Violation < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  scope :recent, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page)
    recent.page(page).per(PER_PAGE)
  end

  # @param [String] text
  # @param [Integer] tolerance
  def self.suspicious?(text, tolerance = 0)
    text.scan(/https?:\/\/[a-z0-9]+/i).length > tolerance
  end

  # @param [ApplicationRecord] entity
  def use_entity(entity)
    if entity.respond_to?(:title)
      self.title = entity.title
    end
    if entity.is_a?(Comment)
      self.tag = "Comment.#{entity.commentable.class}.#{entity.commentable_id}"
    else
      self.tag = entity.class.to_s
    end
    self.user_id = entity.user_id
    self.body    = entity.body
    self.agent   = entity.agent
    self.ip      = entity.ip
  end
end
