class CreateBrowsers < ActiveRecord::Migration[5.0]
  def change
    create_table :browsers do |t|
      t.integer :agents_count, null: false, default: 0
      t.boolean :bot, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.boolean :active, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false
    end
  end
end
