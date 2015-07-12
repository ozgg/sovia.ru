module HasLocation
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_coordinates
  end

  module ClassMethods
  end

  # @param [Array] pair
  def coordinates=(pair)
    if pair.is_a?(Array) and pair.length == 2
      self.latitude  = pair[0].to_f
      self.longitude = pair[1].to_f
    end
  end

  def normalize_coordinates
    self.latitude  = nil unless (-90..90) === self.latitude
    self.longitude = nil unless (-180..180) === self.longitude

    self.latitude, self.longitude = nil, nil if self.latitude.nil? || self.longitude.nil?
  end
end
