class AddCreationIndexToEntries < ActiveRecord::Migration
  def up
    execute "create index entries_created_month_idx on entries using btree (date_trunc('month', created_at));"
  end

  def down
    execute "drop index entries_created_month_idx;"
  end
end
