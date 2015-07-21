module Authentication
  extend ActiveSupport::Concern

  def redirect_authenticated_user
    redirect_to root_path, notice: t(:already_logged_in) unless current_user.nil?
  end

  # @param [User] user
  def create_token_for_user(user)
    token = user.tokens.create!
    cookies['token'] = token.cookie_pair
  end
end
