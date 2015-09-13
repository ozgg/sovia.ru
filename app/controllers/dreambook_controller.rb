class DreambookController < ApplicationController
  before_action :set_letters

  def index
  end

  def search
    @query    = Canonizer.canonize param_from_request(:query)
    @patterns = Pattern.search @query
  end

  def letter
    letter      = letter_from_request
    @patterns   = Pattern.starting_with(letter).order('slug asc').page(current_page).per(50)
  end

  def word
    @pattern = Pattern.match_by_name! params[:word]
  end

  protected

  def letter_from_request
    @letter_from_request ||= params[:letter].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
  end

  def set_letters
    @letters = Pattern.letters
  end
end
