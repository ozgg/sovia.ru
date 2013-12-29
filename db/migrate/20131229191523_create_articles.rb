class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :user, index: true, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end
  end
end
