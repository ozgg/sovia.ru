class AuthController < ApplicationController
  def vk
    redirect_to root_url, notice: t(:auth_failed) and return if session[:state].present? && session[:state] != params[:state]

    @vk = VkontakteApi.authorize(code: params[:code])
    set_vk_account

    session[:lng] = nil

    redirect_to root_url
  end

  protected

  def set_vk_account
    account = Account.find_by(network: 'vk', local_id: @vk.user_id.to_s) || create_vk_account
    account.update(access_token: @vk.token) unless account.access_token == @vk.token
    session[:account_id] = account.id
  end

  def create_vk_account
    account = Account.new vk_parameters
    client  = VkontakteApi::Client.new(@vk.token)
    info    = client.users.get(uid: @vk.user_id, fields: %i(sex screen_name photo_50 photo_200 photo_400 contacts)).first
    account.set_from_vk_hash(info)
    account.save
    session[:account_id] = account.id
    account
  end

  def vk_parameters
    { network: 'vk', local_id: @vk.user_id, access_token: @vk.token }.merge(language_id: session[:lng]).merge(tracking_for_entity)
  end
end
