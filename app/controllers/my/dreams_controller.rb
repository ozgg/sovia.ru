class My::DreamsController < ApplicationController
  before_action :allow_authorized_only

  def index
    page     = params[:page] || 1
    @entries = Entry::Dream.where(user: current_user).order('id desc').page(page).per(5)
    @title   = t('controllers.my.dreams.index', page: page)
  end
end
