class My::SideNotesController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.side_notes.order('id desc').page(current_page).per(10)
  end
end
