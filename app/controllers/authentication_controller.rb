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
      render :new, status: :unauthorized
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
    network = User.networks[params[:provider]]
    data    = request.env['omniauth.auth']
    account = find_account(network, data)
    create_token_for_user(account, tracking_for_entity) if account.allow_login?

    redirect_to root_path
  end

  private

  # @param [Integer] network
  # @param [Hash] data
  def find_account(network, data)
    account = User.find_by(network: network, slug: data[:uid])
    if account.nil?
      account = create_account(network, data)
    end
    if account.email.blank? && !data[:info][:email].blank?
      account.update(email: data[:info][:email])
    end
    account.native_user || account
  end

  # @param [Integer] network
  # @param [Hash] data
  def create_account(network, data)
    parameters = {
        network:         network,
        screen_name:     data[:info][:nickname],
        slug:            data[:uid],
        email:           data[:info][:email],
        name:            data[:info][:name],
        email_confirmed: true,
        allow_mail:      true,
        password_digest: BCrypt::Engine.hash_secret(Time.now.to_s(26), BCrypt::Engine.generate_salt),
    }
    if network == User.networks[:facebook]
      parameters[:screen_name] = data[:info][:name]
    end
    if network == User.networks[:vkontakte]
      if data[:info][:nickname].blank? || (data[:info][:nickname] == "id#{data[:uid]}")
        parameters[:screen_name] = data[:info][:name]
      end
    end
    if data[:info].has_key? :first_name
      parameters[:name] = data[:info][:first_name]
    end
    if data[:info].has_key? :last_name
      parameters[:surname] = data[:info][:last_name]
    end

    big_photo = data.dig(:extra, :raw_info, :photo_400_orig)

    if big_photo.nil?
      unless data[:info][:image].blank?
        parameters[:remote_image_url] = data[:info][:image]
      end
    else
      parameters[:remote_image_url] = big_photo
    end

    unless data[:info][:email].blank?
      parameters[:native_id] = User.native_users.with_email(data[:info][:email]).first&.id
    end

    User.create! parameters.merge(tracking_for_entity)
  end
end
