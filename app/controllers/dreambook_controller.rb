class DreambookController < ApplicationController
  before_action :set_letters

  def index
  end

  def search
    @query    = Canonizer.canonize param_from_request(:query)
    @patterns = Pattern.search language_in_locale, @query
  end

  def letter
    language_id = language_in_locale.id
    letter      = letter_from_request
    @patterns   = Pattern.in_languages(language_id).starting_with(letter).order('slug asc').page(current_page).per(50)
  end

  def word
    @pattern = Pattern.match_by_name! params[:word], language_in_locale
  end

  protected

  def letter_from_request
    @letter_from_request ||= params[:letter].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
  end

  def set_letters
    @letters = Pattern.letters I18n.locale
  end
end
