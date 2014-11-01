class Admin::DreamTagsController < ApplicationController
  before_action { |c| c.demand_role(User::ROLE_EDITOR) }
  before_action :set_dream_tag, only: [:show, :edit, :update, :destroy]

  def index
    check_search
    @tags = collect_tags.page(params[:page] || 1).per(30)
  end

  def new
    @tag = Tag::Dream.new
  end

  def create
    @tag   = Tag::Dream.new(tag_parameters)
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

  def check_search
    unless params[:word].blank?
      tag = Tag::Dream.match_by_name(params[:word])
      if tag
        redirect_to admin_dream_tag_path(tag)
      else
        flash[:notice] = params[:word]
        redirect_to new_admin_dream_tag_path
      end
    end
  end

  def collect_tags
    collector = Tag::Dream.order('name asc')
    unless params[:letter].blank?
      collector.where!(letter: params[:letter])
    end

    collector
  end
end
