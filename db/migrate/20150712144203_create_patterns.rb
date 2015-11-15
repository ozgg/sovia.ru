class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.timestamps null: false
      t.integer :dream_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.string :image
      t.text :description
    end
  end
end
