class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :dream_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.string :name, null: false
      t.string :slug, null: false
      t.string :image
      t.text :description

      t.timestamps null: false
    end

    add_index :patterns, [:slug, :language_id]
  end
end
