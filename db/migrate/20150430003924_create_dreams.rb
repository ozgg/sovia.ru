class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.references :user, index: true
      t.references :place, index: true
      t.references :language, index: true, null: false
      t.references :agent, index: true
      t.inet :ip
      t.integer :privacy, null: false, default: HasPrivacy::PRIVACY_NONE
      t.integer :lucidity, null: false, default: 0
      t.integer :mood, null: false, default: 0
      t.integer :head_direction
      t.integer :body_position
      t.boolean :needs_interpretation, null: false, default: false
      t.boolean :interpretation_given, null: false, default: false
      t.integer :time_of_day
      t.integer :comments_count, null: false, default: 0
      t.boolean :show_image, null: false, default: true
      t.string :image
      t.string :title
      t.text :body, null: false

      t.timestamps
    end

    add_index :dreams, [:language_id, :privacy]
    execute "create index dreams_created_month_idx on dreams using btree (language_id, date_trunc('month', created_at));"
  end
end
