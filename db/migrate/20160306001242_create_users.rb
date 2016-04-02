class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.inet :ip
      t.integer :network, limit: 2, null: false
      t.string :slug, null: false
      t.integer :gender, limit: 2
      t.boolean :deleted, null: false, default: false
      t.boolean :bot, null: false, default: false
      t.boolean :allow_login, null: false, default: true
      t.boolean :email_confirmed, null: false, default: false
      t.boolean :allow_mail, null: false, default: true
      t.datetime :last_seen
      t.integer :dreams_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :balance, null: false, default: 0
      t.string :password_digest
      t.string :email
      t.string :screen_name
      t.string :name
      t.string :image
    end

    add_index :users, [:slug, :network], unique: true
  end
end
