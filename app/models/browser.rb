class Browser < ActiveRecord::Base
  PER_PAGE = 20

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :ordered_by_name, -> { order 'name asc' }

  # @param [Integer] page
  def self.page_for_administration(page)
    self.ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name mobile bot)
  end

  # @param [String] attribute
  def toggle_parameter(attribute)
    if %w(mobile bot).include? attribute
      toggle! attribute
      { attribute => self[attribute] }
    end
  end
end
