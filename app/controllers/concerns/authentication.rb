module Authentication
  extend ActiveSupport::Concern

  def redirect_authenticated_user
    redirect_to root_path, notice: t(:already_logged_in) unless current_user.nil?
  end

  # @param [User] user
  # @param [Hash] tracking
  def create_token_for_user(user, tracking)
    token = user.tokens.create! tracking
    cookies['token'] = token.cookie_pair
  end
end
