class My::IndexController < ApplicationController
  before_action :restrict_anonymous_access
  
  def index
  end
end
