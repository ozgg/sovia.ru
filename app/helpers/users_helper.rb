module UsersHelper
  def user_link(user)
    if user.is_a? User
      link_to user.screen_name, user_profile_path(uid: user.long_uid)
    else
      I18n.t(:anonymous)
    end
  end

  def comment_avatar(user)
    'comment avatar'
  end
end
