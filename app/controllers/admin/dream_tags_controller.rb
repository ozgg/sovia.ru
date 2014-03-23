class Admin::DreamTagsController < ApplicationController
  before_action { |c| c.demand_role(User::ROLE_EDITOR) }
  before_action :set_dream_tag, only: [:show, :edit, :update, :destroy]

  def index
    page  = params[:page] || 1
    @tags = collect_tags.page(page).per(30)
    @title = t('controllers.admin.dream_tags.index', page: page)
  end

  def new
    @tag   = Tag::Dream.new
    @title = t('controllers.admin.dream_tags.new')
  end

  def create
    @title = t('controllers.admin.dream_tags.new')
    @tag   = Tag::Dream.new(tag_parameters)
    if @tag.save
      flash[:notice] = t('tag.created')
      redirect_to admin_dream_tag_path(@tag)
    else
      render action: :new
    end
  end

  def show
    @title = t('controllers.admin.dream_tags.show', name: @tag.name)
  end

  def edit
    @title = t('controllers.admin.dream_tags.edit')
  end

  def update
    @title = t('controllers.admin.dream_tags.edit')
    if @tag.update(tag_parameters)
      flash[:notice] = t('tag.updated')
      redirect_to admin_dream_tag_path(@tag)
    else
      render action: :edit
    end
  end

  def destroy
    if @tag.destroy
      flash[:notice] = t('tag.deleted')
    end

    redirect_to admin_dream_tags_path
  end

  private

  def set_dream_tag
    @tag = Tag::Dream.find(params[:id])
  end

  def tag_parameters
    params.require(:tag_dream).permit(:name, :description)
  end

  def collect_tags
    collector = Tag::Dream.order('name asc')
    unless params[:letter].blank?
      collector.where!(letter: params[:letter])
    end

    collector
  end
end
