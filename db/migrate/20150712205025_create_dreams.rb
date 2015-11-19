class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.references :place, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :privacy, limit: 2, null: false, index: true
      t.integer :lucidity, limit: 2, null: false, default: 0
      t.integer :mood, limit: 2, null: false, default: 0
      t.integer :azimuth, limit: 2
      t.integer :body_position, limit: 2
      t.boolean :needs_interpretation, null: false, default: false
      t.boolean :interpretation_given, null: false, default: false
      t.integer :time_of_day, limit: 2
      t.integer :comments_count, null: false, default: 0
      t.boolean :show_image, null: false, default: true
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :image
      t.string :title
      t.text :body, null: false
      t.string :patterns_cache, array: true, null: false, default: []
    end

    execute "create index dreams_created_month_idx on dreams using btree (date_trunc('month', created_at));"
  end
end
