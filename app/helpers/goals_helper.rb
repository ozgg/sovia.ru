module GoalsHelper
  def goal_statuses_for_select
    Goal.statuses.keys.each.map { |o| [I18n.t("activerecord.attributes.goal.statuses.#{o}"), o] }
  end

  def goals_for_select(current_user)
    [[t(:be_better), '']] + current_user.goals.only_issued.by_name.map { |goal| [goal.name, goal.id] }
  end
end