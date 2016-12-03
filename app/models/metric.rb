class Metric < ApplicationRecord
  include RequiredUniqueName

  METRIC_HTTP_404 = 'errors.http.not_found.hit'

  has_many :metric_values, dependent: :destroy

  def values(period = 7)
    metric_values.where('time > ?', period.days.ago).order('time asc')
  end

  def self.page_for_administration
    order('name asc')
  end

  # @param [String] name
  # @param [Integer] quantity
  def self.register(name, quantity = 1)
    instance = Metric.find_by(name: name) || create(name: name, incremental: !(name =~ /\.hit\z/).nil?)
    instance.metric_values.create(time: Time.now, quantity: quantity)
    value = instance.incremental? ? instance.metric_values.sum(:quantity) : quantity

    instance.update(value: value, previous_value: instance.value)
  end
end
