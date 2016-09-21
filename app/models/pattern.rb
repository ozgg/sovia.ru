class Pattern < ApplicationRecord
  include RequiredUniqueName
  include Toggleable

  toggleable :described

  PER_PAGE = 20

  mount_uploader :image, PatternImageUploader

  scope :visible, -> { where deleted: false }
  scope :ordered_by_popularity, -> { order 'dreams_count desc' }
  scope :described, -> (flag) { where described: flag.to_i > 1 unless flag.blank? }
  scope :filtered, -> (f) { described(f[:described]).with_name_like(f[:name]) }

  # @param [Integer] page
  # @param [Hash] filters
  def self.page_for_administration(page, filters = {})
    filtered(filters).ordered_by_popularity.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page)
    visible.ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(image name essence description described)
  end
end
