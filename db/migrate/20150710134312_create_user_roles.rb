class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :role, limit: 2, null: false
    end

    add_index :user_roles, [:user_id, :role]
  end
end
