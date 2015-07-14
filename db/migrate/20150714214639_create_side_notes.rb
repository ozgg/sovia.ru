class CreateSideNotes < ActiveRecord::Migration
  def change
    create_table :side_notes do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.boolean :active, null: false, default: false
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.string :image
      t.string :link, null: false
      t.string :title, null: false
      t.text :body

      t.timestamps null: false
    end
  end
end
