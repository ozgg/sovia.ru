class Admin::DreamTagsController < ApplicationController
  before_action { |c| c.demand_role(User::ROLE_EDITOR) }
  before_action :set_dream_tag, only: [:show, :edit, :update, :destroy]

  def index
    page = params[:page] || 1
    @tags = Tag::Dream.order('name asc').page(page).per(20)
  end

  def new
    @tag = Tag::Dream.new
  end

  def create
    @tag = Tag::Dream.new(tag_parameters)
    if @tag.save
      flash[:notice] = t('tag.created')
      redirect_to admin_dream_tag_path(@tag)
    else
      render action: :new
    end
  end

  def show

  end

  def edit

  end

  def update
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
end
