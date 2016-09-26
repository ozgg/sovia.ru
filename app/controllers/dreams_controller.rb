class DreamsController < ApplicationController
  private

  def collect_months
    @dates = Hash.new
    Dream.visible.distinct.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end
end
