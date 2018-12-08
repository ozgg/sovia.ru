# frozen_string_literal: true

# Dream component and tables
class CreateDreams < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_sleep_places unless SleepPlace.table_exists?
    create_dreams unless Dream.table_exists?
  end

  def down
    drop_table :dreams if Dream.table_exists?
    drop_table :sleep_places if SleepPlace.table_exists?

    BiovisionComponent.where(slug: 'dreams').destroy_all
    PrivilegeGroup.where(slug: 'dream_managers').destroy_all
    Privilege.where(slug: 'dream_manager').destroy_all
  end

  private

  def create_component
    BiovisionComponent.create(slug: 'dreams', settings: { place_limit: 5 })

    group     = PrivilegeGroup.create(slug: 'dream_managers', name: 'Dream Managers')
    privilege = Privilege.create(slug: 'dream_manager', name: 'Dream Manager')
    group.add_privilege(privilege)
  end

  def create_sleep_places
    create_table :sleep_places, comment: 'Places where users sleep' do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :dreams_count, default: 0, null: false
      t.string :name
    end
  end

  def create_dreams
    create_table :dreams, comment: 'Dreams of users' do |t|
      t.timestamps
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :sleep_place, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.boolean :visible, default: true, null: false
      t.boolean :needs_interpretation, default: false, null: false
      t.boolean :interpreted, default: false, null: false
      t.integer :lucidity, limit: 2, default: 0, null: false
      t.integer :privacy, limit: 2
      t.integer :comments_count, default: 0, null: false
      t.string :title
      t.text :body
    end

    add_index :dreams, %i[visible privacy]
    execute "create index dreams_created_month_idx on dreams using btree (date_trunc('month', created_at));"
  end
end
