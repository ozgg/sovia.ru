class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.integer :post_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end
