class Metric < ApplicationRecord
  include RequiredUniqueName

  has_many :metric_values, dependent: :destroy
end
