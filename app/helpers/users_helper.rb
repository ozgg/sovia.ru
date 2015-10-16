module UsersHelper
  def user_link(user)
    if user.is_a? User
      text = user.screen_name || user.long_uid
      link_to text, user_profile_path(uid: user.long_uid), class: "#{user.network} user"
    else
      I18n.t(:anonymous)
    end
  end

  def comment_avatar(user)
    'comment avatar'
  end

  def dream_avatar(user)
    'dream avatar'
  end
end
