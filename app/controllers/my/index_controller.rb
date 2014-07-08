class My::IndexController < ApplicationController
  before_action :allow_authorized_only

  def index
  end
end
