module Authentication
  extend ActiveSupport::Concern

  def redirect_authenticated_user
    redirect_to root_path unless current_user.nil?
  end

  # @param [User] user
  # @param [Hash] tracking
  def create_token_for_user(user, tracking)
    token = user.tokens.create! tracking
    cookies['token'] = { value: token.cookie_pair, expires: 1.year.from_now }
  end

  def deactivate_token
    token = Token.find_by token: cookies['token'].split(':').last
    token.update active: false
    cookies['token'] = nil
  end
end
