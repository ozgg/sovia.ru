class AuthController < ApplicationController
  def vk
    redirect_to root_path, notice: t(:auth_failed) and return if session[:state].present? && session[:state] != params[:state]

    @vk = VkontakteApi.authorize(code: params[:code])
    set_vk_account

    session[:lng] = nil

    redirect_to root_path
  end

  protected

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
    session[:user_id] = account.id
    account
  end

  def vk_parameters
    language = Language.find_by(id: session[:lng]) || Language.first
    parameters = { network: 'vk', login: @vk.user_id.to_s, access_token: @vk.token }
    parameters.merge(language: language).merge(tracking_for_entity)
    parameters.merge password: session[:state], password_confirmation: session[:state]
  end
end
