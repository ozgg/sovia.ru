module ApplicationHelper
  def title_for_archive(year, month)
    if year
      if month
        ' за ' + t('date.nominative_months')[month.to_i] + " #{year.to_i} года"
      else
        " за #{year.to_i} год"
      end
    end
  end
end
