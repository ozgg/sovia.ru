class PlaceController < ApplicationController

  protected

  def set_place
    @entity = Place.find params[:id]
  end

  def restrict_editing

  end

  def check_ownership
    raise UnauthorizedException unless @entity.owned_by? current_user
  end

  def place_parameters

  end
end
