class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false, index: true
      t.string :secret, null: false
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
