module GoalsHelper
  def goal_statuses_for_select
    Goal.statuses.keys.each.map { |o| [I18n.t("activerecord.attributes.goal.statuses.#{o}"), o] }
  end
end