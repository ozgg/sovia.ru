class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :questions_count, :integer, null: false, default: 0
    add_column :users, :answers_count, :integer, null: false, default: 0
    add_column :users, :rating, :integer, null: false, default: 0
    add_column :users, :upvotes, :integer, null: false, default: 0
    add_column :users, :downvotes, :integer, null: false, default: 0
    add_column :users, :network, :integer, null: false, default: 0
    add_column :users, :name, :string
    add_column :users, :screen_name, :string
    add_column :users, :token_expiry, :datetime
    add_column :users, :access_token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :avatar_url_small, :string
    add_column :users, :avatar_url_medium, :string
    add_column :users, :avatar_url_big, :string

    remove_index :users, :login
    remove_index :users, :email

    add_index :users, [:network, :login], unique: true
    add_index :users, :email
  end
end
