class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true, null: false
      t.references :language, index: true, null: false
      t.integer :rating, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.string :image
      t.string :title, null: false
      t.text :lead
      t.text :body, null: false

      t.timestamps
    end
  end
end
