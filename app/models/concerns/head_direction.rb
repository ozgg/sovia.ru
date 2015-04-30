module HeadDirection
  extend ActiveSupport::Concern

  included do
    enum head_direction: [:north, :north_west, :west, :south_west, :south, :south_east, :east, :north_east]
  end
end
