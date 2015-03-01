class LanguagesController < ApplicationController
  before_action :allow_administrators_only
  before_action :set_language, only: [:show, :edit, :update, :destroy]

  # get /languages
  def index
    @languages = Language.all
  end

  # get /languages/new
  def new
    @language = Language.new
  end

  # post /languages
  def create
    @language = Language.new language_parameters
    if @language.save
      flash[:notice] = t('language.created')
      redirect_to @language
    else
      render action: :new
    end
  end

  # get /languages/:id
  def show
  end

  # get /languages/:id/edit
  def edit
  end

  # patch /languages/:id
  def update
    if @language.update language_parameters
      flash[:notice] = t('language.updated')
      redirect_to @language
    else
      render action: :edit
    end
  end

  # delete /languages/:id
  def destroy
    if @language.destroy
      flash[:notice] = t('language.deleted')
    end

    redirect_to languages_path
  end

  protected

  def set_language
    @language = Language.find params[:id]
  end

  def language_parameters
    params.require(:language).permit(:code, :name, :i18n_name)
  end
end
