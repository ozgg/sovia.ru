class AuthenticationsController < ApplicationController
  before_action :redirect_authenticated_user, except: [:destroy]

  # get /login
  def new
  end

  # post /login
  def create
    user = User.find_by network: 'native', uid: params[:login].to_s
    if user.is_a?(User) && user.authenticate(params[:password].to_s)
      create_token_for_user user
      redirect_to root_path
    else
      render :new
    end
  end

  # delete /logout
  def destroy
    deactivate_token if current_user
    redirect_to root_path
  end

  protected

  def redirect_authenticated_user
    redirect_to root_path, notice: t(:already_logged_in) unless current_user.nil?
  end

  # @param [User] user
  def create_token_for_user(user)
    token = user.tokens.create!
    cookies['token'] = token.cookie_pair
  end

  def deactivate_token
    token = Token.find_by token: cookies['token'].split(':').last
    token.update active: false
    cookies['token'] = nil
  end
end
