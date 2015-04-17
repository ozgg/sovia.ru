class AccountsController < ApplicationController
  before_action :allow_administrators_only
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.order('id asc').page(current_page).per(20)
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new creation_parameters
    if @account.save
      redirect_to @account
    else
      render :new
    end
  end

  def update
    if @account.update account_parameters
      redirect_to @account
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path
  end

  protected

  def account_parameters
    permitted = [
        :network, :name, :screen_name, :local_id, :gender, :language_id,
        :avatar_url_small, :avatar_url_medium, :avatar_url_big
    ]

    params.require(:account).permit(permitted)
  end

  def creation_parameters
    account_parameters.merge(language_for_entity)
  end

  def set_account
    @account = Account.find params[:id]
  end
end
