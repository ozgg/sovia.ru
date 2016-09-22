class CreatePatternWords < ActiveRecord::Migration[5.0]
  def change
    create_table :pattern_words do |t|
      t.references :pattern, foreign_key: true
      t.references :word, foreign_key: true
    end
  end
end
