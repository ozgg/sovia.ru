class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.references :user, index: true, null: false
      t.integer :role, null: false

      t.timestamps
    end

    add_index :user_roles, [:user_id, :role], unique: true
  end
end
