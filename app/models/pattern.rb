class Pattern < ApplicationRecord
  include RequiredUniqueName

  PER_PAGE = 20

  mount_uploader :image, PatternImageUploader

  scope :visible, -> { where deleted: false }
  scope :ordered_by_popularity, -> { order 'dreams_count desc' }
  scope :locked, -> (flag) { where locked: flag.to_i > 1 unless flag.blank? }
  scope :filteres, -> (f) { locked(f[:locked]).with_name_like(f[:name]) }

  def self.page_for_administration(page, filters = {})
    ordered_by_popularity.page(page).per(PER_PAGE)
  end

  def self.page_for_visitors(page)
    visible.ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(image name essence description)
  end
end
