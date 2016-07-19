class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.timestamps
      t.references :user, foreign_key: true, index: true
      t.references :agent, foreign_key: true, index: true
      t.inet :ip
      t.boolean :deleted, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.boolean :visible, null: false, default: true
      t.integer :comments_count, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.string :image
      t.string :title
      t.string :slug
      t.text :lead
      t.text :body, null: false
      t.string :tags_cache, array: true, null: false, default: []
    end

    execute "create index posts_created_month_idx on posts using btree (date_trunc('month', created_at));"
  end
end
