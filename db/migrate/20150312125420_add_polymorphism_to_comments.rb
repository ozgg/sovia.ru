class AddPolymorphismToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string

    execute "update comments set commentable_id = entry_id, commentable_type = 'Entry'"
    execute "update comments set commentable_type = 'Post' where entry_id in (select id from entries where type in ('Entry::Article', 'Entry::Post'))"
  end
end
