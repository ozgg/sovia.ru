module ApplicationHelper
  # @param [Integer] year
  # @param [Integer] month
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

  # @param [ApplicationRecord] entity
  def link_to_delete(entity)
    link_to t(:delete), entity, method: :delete, data: { confirm: t(:are_you_sure) }
  end

  def create_icon(path, title = t(:create), options = {})
    default = { data: { tootik: title } }
    link_to image_tag('icons/create.png', alt: title), path, default.merge(options)
  end

  def back_icon(path, title = t(:back), options = {})
    default = { data: { tootik: title } }
    link_to image_tag('icons/previous.png', alt: title), path, default.merge(options)
  end

  def list_icon(path, title = t(:list), options = {})
    default = { data: { tootik: title } }
    link_to image_tag('icons/list.png', alt: title), path, default.merge(options)
  end

  def edit_icon(path, title = t(:edit), options = {})
    default = { data: { tootik: title } }
    link_to image_tag('icons/edit.png', alt: title), path, default.merge(options)
  end

  def view_icon(path, title = t(:view), options = {})
    default = { data: { tootik: title } }
    link_to image_tag('icons/layout.png', alt: title), path, default.merge(options)
  end

  def detail_icon(path, title = t(:view), options = {})
    default = { data: { tootik: title } }
    link_to image_tag('icons/detail.png', alt: title), path, default.merge(options)
  end

  def destroy_icon(entity, title = t(:delete), options = {})
    default = { method: :delete, data: { confirm: t(:are_you_sure), tootik: title, tootik_conf: 'danger' } }
    link_to image_tag('icons/delete.png', alt: title), entity, default.merge(options)
  end

  def lock_icons(entity, path)
    render partial: 'shared/actions/locks', locals: { path: path, entity: entity }
  end
end
