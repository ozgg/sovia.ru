class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code, null: false
      t.string :slug, null: false
      t.integer :users_count, null: false, default: 0
      t.integer :patterns_count, null: false, default: 0
      t.integer :grains_count, null: false, default: 0
      t.integer :tags_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.integer :dreams_count, null: false, default: 0
      t.integer :questions_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end
