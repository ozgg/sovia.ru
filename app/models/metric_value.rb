class MetricValue < ApplicationRecord
  PER_PAGE = 100

  belongs_to :metric

  validates_presence_of :time, :quantity

  scope :recent, -> { order 'id desc' }

  def self.page_for_administration
    recent.first(PER_PAGE)
  end
end
