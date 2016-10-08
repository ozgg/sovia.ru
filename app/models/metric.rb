class Metric < ApplicationRecord
  include RequiredUniqueName

  has_many :metric_values, dependent: :destroy

  # @param [String] name
  # @param [Integer] quantity
  def self.register(name, quantity = 1)
    instance = Metric.find_or_create_by(name: name)
    instance.metric_values.create(time: Time.now, quantity: quantity)
  end
end
