class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.references :agent, foreign_key: true
      t.inet :ip
      t.integer :network, limit: 2, null: false
      t.integer :native_id
      t.string :slug, null: false
      t.integer :gender, limit: 2
      t.boolean :deleted, null: false, default: false
      t.boolean :bot, null: false, default: false
      t.boolean :allow_login, null: false, default: true
      t.boolean :email_confirmed, null: false, default: false
      t.boolean :phone_confirmed, null: false, default: false
      t.boolean :allow_mail, null: false, default: true
      t.datetime :last_seen
      t.date :birthday
      t.integer :dreams_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.string :password_digest
      t.string :email
      t.string :screen_name
      t.string :name
      t.string :partonymic
      t.string :surname
      t.string :phone
      t.string :image
      t.string :notice
    end

    add_index :users, [:slug, :network], unique: true
  end
end
