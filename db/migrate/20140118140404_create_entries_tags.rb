class CreateEntriesTags < ActiveRecord::Migration
  def change
    create_table :entries_tags do |t|
      t.references :entry, null: false, index: true
      t.references :tag, null: false, index: true
    end

    add_index :entries_tags, [:entry_id, :tag_id], unique: true
  end
end
