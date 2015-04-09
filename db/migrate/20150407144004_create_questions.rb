class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :language, index: true, null: false
      t.integer :owner_id, null: false
      t.string :owner_type, null: false
      t.references :agent, index: true
      t.inet :ip
      t.integer :upvotes, null: false, default: 0
      t.integer :downvotes, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.integer :answers_count, null: false, default: 0
      t.text :body, null: false

      t.timestamps
    end

    add_index :questions, [:owner_type, :owner_id]
  end
end
