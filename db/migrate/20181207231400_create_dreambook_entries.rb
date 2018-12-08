# frozen_string_literal

# Dreambook component and table for legacy dreambook entries
class CreateDreambookEntries < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_dreambook_entries unless DreambookEntry.table_exists?
  end

  def down
    drop_table :dreambook_entries if DreambookEntry.table_exists?

    BiovisionComponent.where(slug: 'dreambook').destroy_all
    PrivilegeGroup.where(slug: 'dreambook_managers').destroy_all
    Privilege.where(slug: 'dreambook_manager').destroy_all
  end

  private

  def create_component
    BiovisionComponent.create(slug: 'dreambook')

    group     = PrivilegeGroup.create(slug: 'dreambook_managers', name: 'Dreambook managers')
    privilege = Privilege.create(slug: 'dreambook_manager', name: 'Dreambook manager')
    group.add_privilege(privilege)
  end

  def create_dreambook_entries
    create_table :dreambook_entries, comment: 'Legacy dreambook entry' do |t|
      t.timestamps
      t.boolean :described, default: false, null: false
      t.boolean :visible, default: true, null: false
      t.string :name, null: false, index: true
      t.string :summary
      t.text :description
    end
  end
end
