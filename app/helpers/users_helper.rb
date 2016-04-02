module UsersHelper
  def networks_for_select
    User.networks.keys.to_a.map { |network| [network, network] }
  end

  def genders_for_select
    genders = [[t(:not_selected), '']]
    genders + User.genders.keys.to_a.map { |gender| [I18n.t("activerecord.attributes.user.genders.#{gender}"), gender] }
  end

  def user_roles(user)
    UserRole.for_user(user).map { |role| I18n.t("activerecord.attributes.user_role.roles.#{role.role}") }
  end

  def user_link(user)
    if user.is_a? User
      if user.deleted?
        t(:anonymous)
      else
        text = user.profile_name
        link_to text, user_profile_path(slug: user.long_slug), class: "profile #{user.network}"
      end
    else
      I18n.t(:anonymous)
    end
  end

  def profile_avatar(user)
    if user.is_a?(User) && !user.image.blank? && !user.deleted?
      image_tag user.image.profile.url
    else
      image_tag 'fallback/avatar/default.png'
    end
  end
end
