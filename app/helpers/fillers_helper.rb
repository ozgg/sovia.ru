module FillersHelper
  def filler_categories_for_select
    Filler.categories.keys.map { |c| [t("activerecord.attributes.filler.categories.#{c}"), c] }
  end

  def filler_genders_for_select
    [[t(:not_selected), '']] + Filler.genders.keys.map { |g| [t("activerecord.genders.#{g}"), g] }
  end
end
