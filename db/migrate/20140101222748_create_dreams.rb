class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.references :user, index: true
      t.integer :privacy, null: false, default: Dream::PRIVACY_NONE
      t.integer :comments_count, null: false, default: 0
      t.string :title
      t.text :body, null: false

      t.timestamps
    end

    add_index :dreams, :privacy
  end
end
