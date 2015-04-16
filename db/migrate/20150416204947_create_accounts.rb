class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :network, null: false
      t.references :user, index: true
      t.references :language, index: true
      t.string :local_id, null: false
      t.string :name
      t.string :screen_name, null: false
      t.string :email
      t.string :avatar
      t.string :avatar_url_small
      t.string :avatar_url_medium
      t.string :avatar_url_big
      t.integer :gender
      t.boolean :verified, null: false, default: false
      t.boolean :allow_mail, null: false, default: true
      t.boolean :allow_login, null: false, default: true
      t.datetime :token_expiry
      t.string :access_token
      t.string :refresh_token
      t.text :data

      t.timestamps
    end

    add_index :accounts, [:network, :local_id]
  end
end
