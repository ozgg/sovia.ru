class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :name, null: false
      t.string :accounts_count, null: false, default: 0

      t.timestamps
    end
  end
end
