class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.references :user, index: true
      t.string :type, null: false
      t.string :body, null: false
      t.string :payload
      t.boolean :activated, null: false, default: false

      t.timestamps
    end

    add_index :codes, :body, unique: true
  end
end
