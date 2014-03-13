class TagsController < ApplicationController
  before_action :check_user_rights
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # get /tags
  def index
    page = params[:page] || 1
    @title = "#{t('titles.tags.index')}, #{t('titles.page')} #{page}"
    @tags = Tag.order('name asc').page(page).per(10)
  end

  # get /tags/new
  def new
    @title = t('tags.index.new_tag')
    @tag   = Tag::Dream.new
  end

  # post /tags
  def create
    @tag = Tag::Dream.new(tag_parameters)
    if @tag.save
      flash[:notice] = t('tag.created')
      redirect_to tag_path(@tag)
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
    if @tag.update(tag_parameters)
      flash[:notice] = t('tag.updated')
      redirect_to tag_path(@tag)
    else
      render action: :edit
    end
  end

  # delete /tags/:id
  def destroy
    @tag.destroy
    flash[:notice] = t('tag.deleted')
    redirect_to tags_path
  end

  private

  def check_user_rights
    raise UnauthorizedException if current_user.nil? || !current_user.editor?
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_parameters
    params[:tag].permit(:name, :description)
  end
end
