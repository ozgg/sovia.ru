# frozen_string_literal: true

# Add foreign sites for external login
class AddForeignSites < ActiveRecord::Migration[5.2]
  def up
    items = {
      facebook: 'facebook',
      vkontakte: 'vkontakte',
      twitter: 'twitter',
      mail_ru: 'mail.ru'
    }

    items.each do |slug, name|
      ForeignSite.create(slug: slug, name: name)
    end
  end

  def down
    # No rollback needed
  end
end
