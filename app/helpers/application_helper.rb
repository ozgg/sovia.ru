module ApplicationHelper
  def user_link(user)
    if user.nil?
      t('anonymous')
    else
      user.login
    end
  end

  def link_to_dream(dream)
    link_to dream.parsed_title, dream_path(dream)
  end
end
