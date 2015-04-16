module UserHelper
  def owners_for_select(user)
    owners = [[user.login, user.id]]
    User.where(bot: true).order('login asc').each { |bot| owners << ["#{bot.login} (#{bot.gender_string})", bot.id]}
    owners
  end
end