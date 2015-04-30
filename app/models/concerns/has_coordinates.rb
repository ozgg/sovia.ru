module HasCoordinates
  extend ActiveSupport::Concern

  included do
    validates_numericality_of :longitude, greater_than: -90, less_than: 90, allow_blank: true
    validates_numericality_of :latitude, greater_than: -180, less_than: 180, allow_blank: true
  end
end
