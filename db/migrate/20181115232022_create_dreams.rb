class CreateDreams < ActiveRecord::Migration[5.2]
  def up
    return if Dream.table_exists?

    create_table :dreams, comment: 'Dreams of users' do |t|
      t.timestamps
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :sleep_place, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.boolean :visible, default: true, null: false
      t.boolean :needs_interpretation, default: false, null: false
      t.boolean :interpreted, default: false, null: false
      t.integer :lucidity, limit: 2, default: 0, null: false
      t.integer :privacy, limit: 2
      t.string :title
      t.text :body
    end

    add_index :dreams, %i[visible privacy]
    execute "create index dreams_created_month_idx on dreams using btree (date_trunc('month', created_at));"
  end

  def down
    drop_table :dreams if Dream.table_exists?
  end
end
