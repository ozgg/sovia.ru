class SearchQuery < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  before_validation { self.body = body.to_s[0..254] }

  scope :recent, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end
end
