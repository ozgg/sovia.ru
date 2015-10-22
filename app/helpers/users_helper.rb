module UsersHelper
  def networks_for_select
    User.networks.keys.to_a.map { |network| [network, network] }
  end

  def genders_for_select
    genders = [t(:not_selected), '']
    genders + User.genders.keys.to_a.map { |gender| [I18n.t("activerecord.attributes.user.genders.#{gender}"), gender] }
  end

  def user_link(user)
    if user.is_a? User
      text = user.screen_name || user.long_uid
      link_to text, user_profile_path(uid: user.long_uid), class: "#{user.network} user"
    else
      I18n.t(:anonymous)
    end
  end

  def comment_avatar(user)
    if user.is_a?(User) && user.image.url
      image_tag user.image.url
    else
      'c.a.'
    end
  end

  def profile_avatar(user)
    if user.is_a?(User) && user.image.url
      image_tag user.image.url
    else
      'p.a.'
    end
  end

  def dream_avatar(user)
    if user.is_a?(User) && user.image
      image_tag user.image.url
    else
      'd.a.'
    end
  end
end
