class CreateSideNotes < ActiveRecord::Migration
  def change
    create_table :side_notes do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.timestamps null: false
      t.boolean :active, null: false, default: false
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :image
      t.string :link, null: false
      t.string :title, null: false
      t.text :body
    end
  end
end
