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
end
