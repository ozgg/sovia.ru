module ApplicationHelper
  def title_for_archive(year, month)
    if year && month
      month_name = t('date.nominative_months')[month.to_i]
      t('archive_month', year: year.to_i, month: month_name)
    elsif year
      t('archive_year', year: year.to_i)
    else
      ''
    end
  end

  def link_to_delete(entity)
    link_to t(:delete), entity, method: :delete, data: { confirm: t(:are_you_sure) }
  end
end
