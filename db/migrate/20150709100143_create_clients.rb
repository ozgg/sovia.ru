class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.timestamps null: false
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.boolean :active, null: false, default: true
      t.string :name, null: false, index: true
      t.string :secret, null: false
    end
  end
end
