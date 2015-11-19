class CreatePostTags < ActiveRecord::Migration
  def change
    create_table :post_tags do |t|
      t.timestamps null: false
      t.references :post, index: true, foreign_key: true, null: false
      t.references :tag, index: true, foreign_key: true, null: false
    end
  end
end
