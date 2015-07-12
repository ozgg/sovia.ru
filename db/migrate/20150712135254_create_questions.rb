class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.boolean :answered, null: false, default: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
