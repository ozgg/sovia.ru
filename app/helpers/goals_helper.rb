module GoalsHelper
  def goal_statuses_for_select
    Goal.statuses.keys.each.map { |o| [I18n.t("activerecord.attributes.goal.statuses.#{o}"), o] }
  end

  def goals_for_select(current_user, only_issued = true)
    goals = only_issued ? current_user.goals.only_issued : current_user.goals
    [[t(:be_better), '']] + goals.by_name.map { |goal| [goal.name, goal.id] }
  end
end