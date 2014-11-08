class DreambookController < ApplicationController
  before_action :collect_letters

  def index
  end

  def letter
    page   = params[:page] || 1
    letter = params[:letter]
    @tags  = Tag::Dream.where(letter: letter).where.not(description: '').order('canonical_name asc').page(page).per(50)
  end

  def word
    @tag = Tag::Dream.match_by_name(params[:word])
    raise record_not_found if @tag.nil?
  end

  def search
    word = Tag::canonize(params[:query] || '')
    if word.blank?
      flash[:notice] = t('query_is_not_set')
      redirect_to dreambook_path
    else
      @tags = Tag::Dream.where('canonical_name like ? and description is not null', "%#{word}%").order('canonical_name asc').limit(50)
    end
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
    @letters = { o: [], r: [], e: [] }
    english_range = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    russian_range = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
    Tag::Dream.uniq.pluck(:letter).each do |letter|
      if english_range.include? letter
        @letters[:e] << letter
      elsif russian_range.include? letter
        @letters[:r] << letter
      else
        @letters[:o] << letter
      end
    end
  end
end
