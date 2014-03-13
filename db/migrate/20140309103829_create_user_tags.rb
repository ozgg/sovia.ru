class CreateUserTags < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.references :user, null: false, index: true
      t.references :tag, null: false, index: true
      t.integer :entries_count, null: false, default: 0
    end

    add_index :user_tags, [:user_id, :tag_id], unique: true
  end
end
