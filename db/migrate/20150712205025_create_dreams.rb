class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true
      t.references :place, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :privacy, null: false
      t.integer :lucidity, null: false, default: 0
      t.integer :mood, null: false, default: 0
      t.integer :azimuth
      t.integer :body_position
      t.boolean :needs_interpretation, null: false, default: false
      t.boolean :interpretation_given, null: false, default: false
      t.integer :time_of_day
      t.integer :comments_count, null: false, default: 0
      t.boolean :show_image, null: false, default: true
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.string :image
      t.string :title
      t.text :body, null: false
      t.string :patterns_cache, array: true, null: false, default: []

      t.timestamps null: false
    end

    add_index :dreams, [:language_id, :privacy]
  end
end
