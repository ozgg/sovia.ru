class CreateDreams < ActiveRecord::Migration[5.0]
  def change
    create_table :dreams do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.references :place, foreign_key: true
      t.inet :ip
      t.integer :privacy, limit: 2, null: false, default: Dream.privacies[:generally_accessible]
      t.boolean :deleted, null: false, default: false
      t.boolean :patterns_set, null: false, default: false
      t.integer :lucidity, limit: 2, null: false, default: 0
      t.integer :mood, limit: 2, null: false, default: 0
      t.boolean :needs_interpretation, null: false, default: false
      t.boolean :interpretation_given, null: false, default: false
      t.integer :comments_count, null: false, default: 0
      t.boolean :show_image, null: false, default: true
      t.string :uuid, null: false
      t.string :image
      t.string :title
      t.string :slug
      t.text :body, null: false
    end

    execute "create index dreams_created_month_idx on dreams using btree (date_trunc('month', created_at));"
  end
end
