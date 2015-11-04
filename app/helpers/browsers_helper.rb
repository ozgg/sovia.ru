module BrowsersHelper
  def browsers_for_select
    [[t(:not_selected), '']] + Browser.by_name.map { |b| [b.name, b.id] }
  end
end