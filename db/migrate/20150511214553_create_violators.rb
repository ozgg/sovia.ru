class CreateViolators < ActiveRecord::Migration
  def change
    create_table :violators do |t|
      t.references :agent, index: true, null: false
      t.inet :ip, null: false

      t.timestamps
    end

    add_index :violators, :ip
  end
end
