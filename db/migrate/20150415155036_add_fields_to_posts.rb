class AddFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :upvotes, :integer, null: false, default: 0
    add_column :posts, :downvotes, :integer, null: false, default: 0
    add_column :posts, :ip, :inet
    add_reference :posts, :agent, index: true
    add_column :posts, :show_in_list, :boolean, null: false, default: true
  end
end
