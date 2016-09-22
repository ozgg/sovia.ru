class Word < ApplicationRecord
  include Toggleable

  BODY_LIMIT = 50
  PER_PAGE   = 20

  toggleable :significant

  validates_presence_of :body
  validates_uniqueness_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  before_validation :normalize_body

  scope :ordered_by_weight, -> { order 'dreams_count desc, body asc' }
  scope :significant, -> (flag) { where significant: flag.to_i > 0 unless flag.blank? }
  scope :processed, -> (flag) { where processed: flag.to_i > 0 unless flag.blank? }
  scope :with_body_like, -> (body) { where 'body like ?', body unless body.blank? }
  scope :with_body, -> (body) { where body: body.mb_chars.downcase.to_s.strip unless body.blank? }
  scope :filtered, -> (f) { processed(f[:processed]).significant(f[:significant]).with_body_like(f[:body]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page, filter = {})
    filtered(filter).ordered_by_weight.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(significant body)
  end

  private

  def normalize_body
    self.body = body.mb_chars.downcase.to_s.strip
  end
end
