class CreateDreamWords < ActiveRecord::Migration[5.0]
  def change
    create_table :dream_words do |t|
      t.references :dream, foreign_key: true, null: false
      t.references :word, foreign_key: true, null: false
    end
  end
end
