class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.text :body
    end
  end
end
