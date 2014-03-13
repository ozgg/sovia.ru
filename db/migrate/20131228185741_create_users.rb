class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :email
      t.string :password_digest, null: false
      t.string :avatar
      t.boolean :mail_confirmed, null: false, default: false
      t.boolean :allow_mail, null: false, default: false
      t.integer :entries_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :roles_mask, null: false, default: 0

      t.timestamps
    end

    add_index :users, :login, unique: true
    add_index :users, :email, unique: true
  end
end
