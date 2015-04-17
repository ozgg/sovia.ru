class AddFieldsToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :agent, index: true
    add_column :accounts, :ip, :inet
    add_column :accounts, :rating, :integer, null: false, default: 0
    add_column :accounts, :upvotes, :integer, null: false, default: 0
    add_column :accounts, :downvotes, :integer, null: false, default: 0
    add_column :accounts, :questions_count, :integer, null: false, default: 0
    add_column :accounts, :answers_count, :integer, null: false, default: 0
    add_column :accounts, :dreams_count, :integer, null: false, default: 0
    add_column :accounts, :posts_count, :integer, null: false, default: 0
    add_column :accounts, :comments_count, :integer, null: false, default: 0
  end
end
