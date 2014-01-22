module ApplicationHelper
  def user_link(user)
    if user.nil?
      t('anonymous')
    else
      user.login
    end
  end

  def user_avatar(user)
    if user.nil? || user.email.nil? || user.email.empty?
      image_tag 'smile.png'
    else
      hash = Digest::MD5.hexdigest(user.email.downcase)
      url  = "http://www.gravatar.com/avatar/#{hash}?s=100&amp;d=identicon"
      image_tag url
    end
  end


  def link_to_dream(dream)
    link_to dream.parsed_title, dream_path(dream)
  end
end
