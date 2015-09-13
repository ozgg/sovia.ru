class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :name, null: false, index: true
      t.boolean :bot, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.integer :agents_count, null: false, default: 0
    end
  end
end
