class DreambookController < ApplicationController
  before_action :collect_letters

  def index
    @title = t('controllers.dreambook.index')
  end

  def letter
    page   = params[:page] || 1
    letter = params[:letter]
    @tags  = Tag::Dream.where(letter: letter).where.not(description: '').order('name asc').page(page).per(50)
    @title = t('controllers.dreambook.letter', letter: letter, page: page)
  end

  def word
    word = params[:word]
    @tag = Tag::Dream.match_by_name(word)
    raise record_not_found if @tag.nil?
    @title = t('controllers.dreambook.word', word: word)
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
    @letters = Tag::Dream.uniq.pluck(:letter).sort
  end
end
