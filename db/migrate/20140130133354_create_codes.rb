class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.references :user, index: true
      t.integer :code_type, null: false
      t.string :body, null: false
      t.boolean :activated, null: false, default: false

      t.timestamps
    end

    add_index :codes, :body, unique: true
  end
end
