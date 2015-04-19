class AuthController < ApplicationController
  def vk
    redirect_to root_path, notice: t(:auth_failed) and return if session[:state].present? && session[:state] != params[:state]

    @vk = VkontakteApi.authorize(code: params[:code])
    set_vk_account

    session[:lng] = nil

    redirect_to root_path
  end

  def external
    render plain: params[:provider]
  end

  def callback
    message = "set_#{params[:provider]}_account"
    send message if respond_to? message, true

    redirect_to root_path
  end

  protected

  def set_twitter_account
    data = request.env['omniauth.auth']
    account = User.find_by(network: User.networks[:twitter], login: data[:uid]) || create_twitter_account(data)
    account.update(access_token: data[:credentials][:token], refresh_token: data[:credentials][:secret])
    session[:user_id] = account.id
  end

  def create_twitter_account(data)
    parameters = { network: 'twitter', login: data[:uid] }
    parameters.merge! tracking_for_entity
    parameters.merge! password: 'none', password_confirmation: 'none'
    parameters.merge! language: (Language.find_by(id: session[:lng]) || Language.first)
    account = User.new parameters
    account.name = data[:info][:name]
    account.screen_name = data[:info][:nickname]
    account.avatar_url_medium = data[:info][:image]
    account.save!
    account
  end

  def set_facebook_account
    data = request.env['omniauth.auth']
    account = User.find_by(network: User.networks[:fb], login: data[:uid]) || create_facebook_account(data)
    account.update(access_token: data[:credentials][:token], token_expiry: DateTime.strptime(data[:credentials][:expires_at].to_s, '%s'))
    session[:user_id] = account.id
  end

  def create_facebook_account(data)
    parameters = { network: 'fb', login: data[:uid] }.merge(tracking_for_entity)
    parameters.merge! language: (Language.find_by(id: session[:lng]) || Language.first)
    account = User.new parameters
    account.set_from_auth_hash data
    account.save!
    account
  end

  def set_mail_ru_account
    data = request.env['omniauth.auth']
    account = User.find_by(network: User.networks[:mail_ru], login: data[:uid]) || create_mail_ru_account(data)
    account.update(access_token: data[:credentials][:token], token_expiry: DateTime.strptime(data[:credentials][:expires_at].to_s, '%s'), refresh_token: data[:credentials][:refresh_token])
    session[:user_id] = account.id
  end

  def create_mail_ru_account(data)
    parameters = { network: 'mail_ru', login: data[:uid] }.merge(tracking_for_entity)
    parameters.merge! language: (Language.find_by(id: session[:lng]) || Language.first)
    account = User.new parameters
    account.set_from_auth_hash data
    account.save!
    account
  end

  def set_vk_account
    account = User.find_by(network: User.networks[:vk], login: @vk.user_id.to_s) || create_vk_account
    account.update(access_token: @vk.token) unless account.access_token == @vk.token
    session[:user_id] = account.id
  end

  def create_vk_account
    account = User.new vk_parameters
    client  = VkontakteApi::Client.new(@vk.token)
    info    = client.users.get(uid: @vk.user_id, fields: %i(sex screen_name photo_50 photo_200 photo_400 contacts)).first
    account.set_from_vk_hash(info)
    account.save!
    account
  end

  def vk_parameters
    language = Language.find_by(id: session[:lng]) || Language.first
    parameters = { network: 'vk', login: @vk.user_id.to_s, access_token: @vk.token }
    parameters.merge!(language: language).merge(tracking_for_entity)
    parameters.merge password: session[:state], password_confirmation: session[:state]
  end
end
