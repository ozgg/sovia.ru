class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :network, limit: 2, null: false
      t.integer :user_id
      t.integer :inviter_id
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.integer :dreams_count, null: false, default: 0
      t.integer :questions_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :gender, limit: 2
      t.boolean :deleted, null: false, default: false
      t.boolean :bot, null: false, default: false
      t.boolean :allow_login, null: false, default: true
      t.boolean :email_confirmed, null: false, default: false
      t.boolean :allow_mail, null: false, default: false
      t.datetime :last_seen
      t.string :uid, null: false
      t.string :password_digest
      t.string :email, index: true
      t.string :screen_name
      t.string :name
      t.string :image
    end

    add_index :users, [:uid, :network]
  end
end
