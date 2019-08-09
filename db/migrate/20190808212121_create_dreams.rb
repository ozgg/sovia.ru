# frozen_string_literal: true

# Create tables and record for dreams component
class CreateDreams < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_sleep_places
    create_dreams
  end

  def down
    drop_table :dreams if Dream.table_exists?
    drop_table :sleep_places if SleepPlace.table_exists?
  end

  private

  def create_component
    slug = Biovision::Components::DreamsComponent::SLUG

    return if BiovisionComponent.where(slug: slug).exists?

    settings = {
      place_limit: 2
    }

    BiovisionComponent.create!(slug: slug, settings: settings)
  end

  def create_sleep_places
    create_table :sleep_places, comment: 'Sleep place' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :dreams_count, default: 0, null: false
      t.timestamps
      t.string :name, null: false
    end
  end

  def create_dreams
    create_table :dreams, comment: 'Dream' do |t|
      t.uuid :uuid, index: true
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :sleep_place, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.timestamps
      t.boolean :visible, default: true, null: false
      t.integer :lucidity, limit: 2, default: 0, null: false
      t.integer :privacy, limit: 2, default: 0, null: false
      t.integer :comments_count, default: 0, null: false
      t.string :title
      t.text :body, null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :dreams, %i[visible privacy]
    execute "create index dreams_created_month_idx on dreams using btree (date_trunc('month', created_at));"
  end
end
