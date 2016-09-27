class DreamsController < ApplicationController

  # get /dreams/tagged/:tag_name
  def tagged
    set_tag
    @collection = Dream.tagged(@tag).page_for_visitors(current_user, current_page)
  end

  # get /dreams/archive/(:year)/(:month)
  def archive
    collect_months
    unless params[:month].nil?
      @collection = Dream.archive(params[:year], params[:month]).page_for_visitors current_user, current_page
    end
  end

  private

  def set_entity
    @entity = Dream.find params[:id]
  end

  def set_tag
    @tag = Pattern.find_by! name: params[:tag_name]
  end

  def collect_months
    @dates = Hash.new
    Dream.visible.distinct.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end
end
