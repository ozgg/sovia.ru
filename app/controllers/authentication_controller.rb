class AuthenticationController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user, except: [:destroy]

  # get /login
  def new
  end

  # post /login
  def create
    user = User.find_by network: 'native', slug: params[:login].to_s.downcase
    if user.is_a?(User) && user.authenticate(params[:password].to_s) && user.allow_login?
      create_token_for_user user, tracking_for_entity
      redirect_to root_path
    else
      flash.now[:alert] = t(:could_not_log_in)
      render :new
    end
  end

  # delete /logout
  def destroy
    deactivate_token if current_user
    redirect_to root_path
  end

  # get /auth/:provider
  def external
    render plain: params[:provider]
  end

  # get /auth/:provider/callback
  def callback
    provider, data = params[:provider], request.env['omniauth.auth']
    account = User.find_by(network: User.networks[provider], slug: data[:uid]) || create_account(provider, data)
    create_token_for_user account, tracking_for_entity if account.allow_login?


    message = "set_#{params[:provider]}_account"
    send message if respond_to? message, true

    redirect_to root_path
  end

  private

  def deactivate_token
    token = Token.find_by token: cookies['token'].split(':').last
    token.update active: false
    cookies['token'] = nil
  end

  # @param [String] provider
  # @param [Hash] data
  def create_account(provider, data)
    parameters = {
        network: User.networks[provider],
        screen_name: data[:info][:nickname],
        slug: data[:uid],
        email: data[:info][:email],
        name: data[:info][:name],
        email_confirmed: true,
        allow_mail: true,
        password_digest: BCrypt::Engine.hash_secret(Time.now.to_s(26), BCrypt::Engine.generate_salt),
    }
    parameters[:remote_image_url] = data[:info][:image] unless data[:info][:image].blank?

    User.create! parameters.merge(tracking_for_entity)
  end
end
