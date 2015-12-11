class PatternsController < ApplicationController
  before_action :restrict_access, except: [:show]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    if params[:queue]
      @collection = Pattern.queue_page_for_administrator current_page
    else
      @collection = Pattern.page_for_administrator current_page
    end
  end

  def new
    @entity = Pattern.new
  end

  def create
    @entity = Pattern.new creation_parameters
    if @entity.save
      set_links
      redirect_to @entity
    else
      render :new
    end
  end

  def show
    set_adjacent_patterns
    unless current_user_has_role? :administrator
      redirect_to dreambook_word_path(letter: @entity.letter, word: @entity.name)
    end
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      set_links
      redirect_to @entity, notice: t('patterns.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('patterns.delete.success')
    end
    redirect_to patterns_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Pattern.find params[:id]
  end

  def entity_parameters
    params.require(:pattern).permit(:name, :essence, :image, :description, :locked)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def set_links
    @entity.links = params[:links].nil? ? Hash.new : params[:links]
  end

  def set_adjacent_patterns
    @adjacent = {
        prev: Pattern.earlier_than(@entity.created_at).last,
        next: Pattern.later_than(@entity.created_at).first
    }
  end
end
