class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, index: true, null: false
      t.integer :owner_id, null: false
      t.string :owner_type, null: false
      t.references :agent, index: true
      t.inet :ip
      t.integer :upvotes, null: false, default: 0
      t.integer :downwotes, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.text :body, null: false

      t.timestamps
    end

    add_index :answers, [:owner_type, :owner_id]
  end
end
