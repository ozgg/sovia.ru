class My::PostsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.posts.order('id desc').page(current_page).per(10)
  end

  def tagged
    @tag = Tag.match_by_name params[:tag_name], Language.find_by(code: locale)
    raise record_not_found unless @tag.is_a? Tag
    selection   = Post.where(user:current_user).joins(:post_tags).where(post_tags: { tag: @tag })
    @collection = selection.page(current_page).per(10)
  end

  def archive
    @dates = {}
    collect_months
    collect_archive unless params[:month].nil?
  end

  protected

  def collect_months
    Post.owned_by(current_user).uniq.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end

  def collect_archive
    first_day   = '%04d-%02d-01 00:00:00' % [params[:year], params[:month]]
    @collection = Post.owned_by(current_user).where("date_trunc('month', created_at) = '#{first_day}'").page(current_page).per(20)
  end
end
