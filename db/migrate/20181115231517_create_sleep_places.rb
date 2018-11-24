class CreateSleepPlaces < ActiveRecord::Migration[5.2]
  def up
    return if SleepPlace.table_exists?

    create_table :sleep_places, comment: 'Places where users sleep' do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :dreams_count, default: 0, null: false
      t.string :name
    end
  end

  def down
    drop_table :sleep_places if SleepPlace.table_exists?
  end
end
