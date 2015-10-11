class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.boolean :show_in_list, null: false, default: false, index: true
      t.string :title, null: false
      t.string :image
      t.string :lead, null: false
      t.text :body, null: false
      t.string :tags_cache, array: true, null: false, default: []

      t.timestamps null: false
    end

    execute "create index posts_created_month_idx on posts using btree (date_trunc('month', created_at));"
  end
end