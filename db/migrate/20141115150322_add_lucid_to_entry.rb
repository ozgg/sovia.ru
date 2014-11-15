class AddLucidToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :lucid, :boolean
  end
end
