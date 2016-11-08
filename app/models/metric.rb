class Metric < ApplicationRecord
  include RequiredUniqueName

  has_many :metric_values, dependent: :destroy

  def self.page_for_administration
    order('name asc')
  end

  # @param [String] name
  # @param [Integer] quantity
  def self.register(name, quantity = 1)
    instance = Metric.find_or_create_by(name: name)
    instance.metric_values.create(time: Time.now, quantity: quantity)
    value = instance.incremental? ? instance.metric_values.sum(:quantity) : quantity

    instance.update(value: value)
  end
end
