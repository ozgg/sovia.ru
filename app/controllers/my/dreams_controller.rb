class My::DreamsController < ApplicationController
  before_action :allow_authorized_only

  # get /my/dreams
  def index
    @entries = my_dreams.page(params[:page] || 1).per(5)
  end

  # get /my/dreams/tagged/:tag
  def tagged
    @entries = tagged_dreams.page(params[:page] || 1).per(5)
  end
  
  protected

  def tagged_dreams
    @tag = Tag::Dream.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    my_dreams.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end

  def my_dreams
    Entry::Dream.where(user: current_user).order('id desc')
  end
end
