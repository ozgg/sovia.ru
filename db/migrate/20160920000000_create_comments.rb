class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.boolean :visible, null: false, default: true
      t.boolean :deleted, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.integer :commentable_id, null: false
      t.string :commentable_type, null: false
      t.text :body, null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
