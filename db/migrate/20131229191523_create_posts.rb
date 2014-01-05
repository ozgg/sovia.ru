class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.integer :entry_type, null: false
      t.integer :privacy, null: false, default: Post::PRIVACY_NONE
      t.string :title
      t.string :url_title
      t.text :body, null: false
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end

    add_index :posts, [:entry_type, :privacy]
  end
end
