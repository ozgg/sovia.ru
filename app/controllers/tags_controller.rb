class TagsController < ApplicationController
  before_action :check_user_rights
  before_action :set_entry_tag, only: [:show, :edit, :update, :destroy]

  # get /tags
  def index
    page = params[:page] || 1
    @title = "#{t('titles.tags.index')}, #{t('titles.page')} #{page}"
    @tags = EntryTag.order('name asc').page(page).per(10)
  end

  # get /tags/new
  def new
    @title = t('tags.index.new_tag')
    @tag   = EntryTag.new
  end

  # post /tags
  def create
    @tag = EntryTag.new(entry_tag_parameters)
    if @tag.save
      flash[:message] = t('tag.added')
      redirect_to @tag
    else
      render action: :new
    end
  end

  # post /tags/:id
  def show
    @title = "#{t('tags.show.tag')} «#{@tag.name}»"
  end

  # get /tags/:id/edit
  def edit

  end

  # patch /tags/:id
  def update
    if @tag.update(entry_tag_parameters)
      flash[:message] = t('tag.updated')
      redirect_to @tag
    else
      render action: :edit
    end
  end

  # delete /tags/:id
  def destroy
    @tag.destroy
    flash[:message] = t('tag.deleted')
    redirect_to entry_tags_path
  end

  private

  def check_user_rights
    raise UnauthorizedException if @current_user.nil? || !@current_user.editor?
  end

  def set_entry_tag
    @tag = EntryTag.find(params[:id])
  end

  def entry_tag_parameters
    params[:entry_tag].permit(:name, :description)
  end
end
