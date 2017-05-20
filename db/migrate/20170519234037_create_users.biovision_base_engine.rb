# This migration comes from biovision_base_engine (originally 20170302000001)
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :inviter_id
      t.integer :follower_count, default: 0, null: false
      t.integer :followee_count, default: 0, null: false
      t.integer :authority, default: 0, null: false
      t.integer :upvote_count, default: 0, null: false
      t.integer :downvote_count, default: 0, null: false
      t.integer :vote_result, default: 0, null: false
      t.boolean :super_user, default: false, null: false
      t.boolean :foreign_slug, default: false, null: false
    end

    add_index :users, :screen_name
    add_index :users, :email
  end
end
