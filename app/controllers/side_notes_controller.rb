class SideNotesController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index, :show]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]
  
  def index
    if current_user_has_role? :administrator
      @collection = SideNote.in_languages(visitor_languages).order('id desc').page(current_page).per(25)
    else
      @collection = SideNote.in_languages(visitor_languages).visible.order('id desc').page(current_page).per(25)
    end
  end

  def new
    @entity = SideNote.new
  end

  def create
    @entity = SideNote.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('side_notes.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('side_notes.delete.success')
    end
    redirect_to side_notes_path
  end

  protected

  def restrict_editing
    raise UnauthorizedException unless @entity.editable_by? current_user
  end

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = SideNote.find params[:id]
  end

  def entity_parameters
    parameters = SideNote.parameters_for_users
    parameters.merge SideNote.parameters_for_administrators if current_user_has_role? :administrator
    params.require(:side_note).permit(parameters)
  end

  def creation_parameters
    entity_parameters.merge(language_for_entity).merge(tracking_for_entity).merge(owner_for_entity)
  end
end
