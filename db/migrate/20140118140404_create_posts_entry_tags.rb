class CreatePostsEntryTags < ActiveRecord::Migration
  def change
    create_table :post_entry_tags do |t|
      t.references :post, null: false, index: true
      t.references :entry_tag, null: false, index: true
    end

    add_index :post_entry_tags, [:post_id, :entry_tag_id], unique: true
  end
end
