class My::ThoughtsController < ApplicationController
  before_action :allow_authorized_only

  def index
    page     = params[:page] || 1
    @entries = Entry::Thought.where(user: current_user).order('id desc').page(page).per(5)
    @title   = t('controllers.my.thoughts.index', page: page)
  end
end
