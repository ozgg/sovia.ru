module UserHelper
  def owners_for_select(user)
    owners = [[user.login, user.id]]
    User.where(bot: true).each { |bot| owners << [bot.login, bot.id]}
    owners
  end
end