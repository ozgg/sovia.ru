class DreamsController < ApplicationController
  before_action :set_dream, only: [:show, :edit, :update, :destroy]
  before_action :check_rights, only: [:show]
  before_action :allow_only_registered, only: [:edit, :update, :destroy]
  before_action :allow_only_owner, only: [:edit, :update, :destroy]

  # get /dreams
  def index
    page    = params[:page] || 1
    @dreams = Dream.order('id desc').page(page).per(5)
  end

  # get /dreams/:id
  def show

  end

  # get /dreams/new
  def new
    @dream = Dream.new
  end

  # post /dreams
  def create
    @dream = Dream.new(dream_parameters)
    if @dream.save
      flash[:message] = t('dream.added')
      redirect_to dream_path @dream
    else
      render action: 'new'
    end
  end

  # get /dreams/:id/edit
  def edit

  end

  # patch /dreams/:id
  def update

  end

  # delete /dreams/:id
  def destroy

  end

  private

  def set_dream
    @dream = Dream.find(params[:id])
  end

  def dream_parameters
    params[:dream].permit(:title, :body)
  end

  def check_rights
    unless @dream.open?
      if @dream.users_only?
        allow_only_registered
      else
        allow_only_owner
      end
    end
  end

  def restrict_access
    flash[:message] = t('roles.insufficient_rights')
    redirect_to dreams_path
  end

  def allow_only_registered
    restrict_access if @current_user.nil?
  end

  def allow_only_owner
    restrict_access unless @dream.user == @current_user
  end
end
