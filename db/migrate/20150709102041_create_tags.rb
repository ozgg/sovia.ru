class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :post_count, null: false, default: 0

      t.timestamps null: false
    end

    add_index :tags, [:slug, :language_id]
  end
end
