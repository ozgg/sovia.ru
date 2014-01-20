class DreambookController < ApplicationController
  before_action :collect_letters

  def index
  end

  def letter
    page  = params[:page] || 1
    @tags = EntryTag.where(letter: params[:letter]).where.not(description: '').order('name asc').page(page).per(50)
  end

  def word
    @tag = EntryTag.match_by_name(params[:word])
    raise record_not_found if @tag.nil?
  end

  def obsolete
    if params[:word]
      redirect_to dreambook_word_path(letter: params[:letter], word: params[:word]), status: :moved_permanently
    else
      redirect_to dreambook_letter_path(letter: params[:letter]), status: :moved_permanently
    end
  end

  private

  def collect_letters
    @letters = EntryTag.uniq.pluck(:letter)
  end
end
