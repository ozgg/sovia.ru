class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :parent_id
      t.integer :commentable_id, null: false
      t.string :commentable_type, null: false
      t.boolean :best, null: false, default: false
      t.boolean :visible, null: false, default: true
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.text :body, null: false

      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
