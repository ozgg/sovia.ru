class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :name, null: false
      t.boolean :bot, null: false, default: false
      t.integer :agents_count, null: false, default: true
    end

    add_index :browsers, :name
  end
end
