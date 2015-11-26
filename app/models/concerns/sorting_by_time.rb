module SortingByTime
  extend ActiveSupport::Concern

  included do
    scope :recent, -> { order 'created_at desc' }
    scope :earlier_than, ->(time) { where 'created_at < ?', time }
    scope :later_than, ->(time) { where 'created_at > ?', time }
  end

  module ClassMethods
  end

  # Format time in W3C (e.g. for datetime attribute in time tag)
  def pubdate_w3c
    created_at.strftime('%Y-%m-%dT%H:%M:%S%:z')
  end

  def pubdate_iso
    created_at.strftime('%Y-%m-%d')
  end

  def pubdate_microformat
    created_at.strftime('%Y-%m-%dT%H:%M')
  end

  def pubdate
    created_at.strftime('%d.%m.%Y, %H:%M')
  end
end
