# frozen_string_literal: true

# Tables for linking dreams, patterns and words
class CreatePatterns < ActiveRecord::Migration[5.2]
  def up
    create_patterns_table unless Pattern.table_exists?
    create_words_table unless Word.table_exists?
    create_pattern_links unless DreamPattern.table_exists?
    create_word_links unless DreamWord.table_exists?
  end

  def down
    drop_table :dream_words if DreamWord.table_exists?
    drop_table :dream_patterns if DreamPattern.table_exists?
    drop_table :words if Word.table_exists?
    drop_table :patterns if Pattern.table_exists?
  end

  private

  def create_patterns_table
    create_table :patterns, comment: 'Dream pattern' do |t|
      t.timestamps
      t.integer :dreams_count, default: 0, null: false
      t.integer :words_count, default: 0, null: false
      t.string :name, null: false, index: true
      t.string :summary
    end
  end

  def create_words_table
    create_table :words, comment: 'Word used in dream plot' do |t|
      t.timestamps
      t.references :pattern, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.boolean :processed, default: false, null: false
      t.integer :dreams_count, default: 0, null: false
      t.string :body, null: false, index: true
    end
  end

  def create_pattern_links
    create_table :dream_patterns, comment: 'Usage of pattern in dream' do |t|
      t.timestamps
      t.references :dream, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :weight, default: 0, null: false
    end
  end

  def create_word_links
    create_table :dream_words, comment: 'Usage of word in dream' do |t|
      t.timestamps
      t.references :dream, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :word, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :weight, default: 0, null: false
    end
  end
end
