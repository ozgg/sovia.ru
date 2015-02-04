module DeedsHelper
  def goals_for_select(user)
    goals = [[I18n.t('be_better'), '']]
    if user.is_a? User
      Goal.active_goals(user).each do |goal|
        goals << [goal.name, goal.id]
      end
    end
    goals
  end
end