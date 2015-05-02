module PositionHelper
  def head_directions_for_form
    positions = [[I18n.t(:not_selected), '']]
    Place.head_directions.keys.to_a.map { |e| positions << [I18n.t("activerecord.head_directions.#{e}"), e] }
    positions
  end
end
