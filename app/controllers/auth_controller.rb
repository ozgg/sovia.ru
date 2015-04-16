class AuthController < ApplicationController
  def vk
    redirect_to root_url, notice: t(:auth_failed) and return if session[:state].present? && session[:state] != params[:state]

    @vk = VkontakteApi.authorize(code: params[:code])
    session[:token] = @vk.token
    session[:vk_id] = @vk.user_id

    redirect_to root_url
  end
end
