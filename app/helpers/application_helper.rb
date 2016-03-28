module ApplicationHelper
  def link_to_delete(entity)
    link_to t(:delete), entity, method: :delete, data: { confirm: t(:are_you_sure) }
  end
end
