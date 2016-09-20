class CreateUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_roles do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :role, limit: 2, null: false
    end
  end
end
