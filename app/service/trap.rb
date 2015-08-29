class Trap
  def self.suspect_spam?(user, text, tolerance = 1)
    if user.nil? || !user.decent?
      tolerance += tolerance_delta(user) if user.is_a?(User)
      text.scan(/https?:\/\//).length >= tolerance
    else
      false
    end
  end

  protected

  # @param [User] user
  def self.tolerance_delta(user)
    delta = 0
    delta += 1 if user.email_confirmed?
    delta += 1 if user.dreams_count > 10 && user.comments_count > 30
    delta
  end
end