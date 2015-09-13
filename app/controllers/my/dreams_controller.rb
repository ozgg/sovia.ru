class My::DreamsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.dreams.order('id desc').page(current_page).per(10)
  end

  def tagged
    @grain = Grain.match_by_name! params[:tag_name], current_user
    set_collection_with_grains
  end

  def archive
    @dates = {}
    collect_months
    collect_archive unless params[:month].nil?
  end

  protected

  def set_collection_with_grains
    selection   = Dream.where(user: current_user).joins(:dream_grains).where(dream_grains: { grain: @grain })
    @collection = selection.page(current_page).per(10)
  end

  def collect_months
    Dream.owned_by(current_user).uniq.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end

  def collect_archive
    first_day   = '%04d-%02d-01 00:00:00' % [params[:year], params[:month]]
    @collection = Dream.owned_by(current_user).where("date_trunc('month', created_at) = '#{first_day}'").page(current_page).per(20)
  end
end
