# frozen_string_literal: true

# Dreambook component and tables
class CreateDreambook < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_patterns_table unless Pattern.table_exists?
    create_words_table unless Word.table_exists?
    create_pattern_words unless PatternWord.table_exists?
    create_pattern_links unless DreamPattern.table_exists?
    create_word_links unless DreamWord.table_exists?
    create_dreambook_entries unless DreambookEntry.table_exists?
  end

  def down
    drop_table :dreambook_entries if DreambookEntry.table_exists?
    drop_table :dream_words if DreamWord.table_exists?
    drop_table :dream_patterns if DreamPattern.table_exists?
    drop_table :pattern_words if PatternWord.table_exists?
    drop_table :words if Word.table_exists?
    drop_table :patterns if Pattern.table_exists?

    BiovisionComponent.where(slug: 'dreambook').destroy_all
    PrivilegeGroup.where(slug: 'dreambook_managers').destroy_all
    Privilege.where(slug: 'dreambook_manager').destroy_all
  end

  private

  def create_component
    BiovisionComponent.create(slug: 'dreambook')

    group     = PrivilegeGroup.create(slug: 'dreambook_managers', name: 'Dreambook managers')
    privilege = Privilege.create(slug: 'dreambook_manager', name: 'Dreambook manager')
    group.add_privilege(privilege)
  end

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
      t.boolean :processed, default: false, null: false
      t.integer :dreams_count, default: 0, null: false
      t.integer :patterns_count, default: 0, null: false
      t.string :body, null: false, index: true
    end
  end

  def create_pattern_words
    create_table :pattern_words, comment: 'Link between word and pattern' do |t|
      t.timestamps
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :word, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
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

  def create_dreambook_entries
    create_table :dreambook_entries, comment: 'Legacy dreambook entry' do |t|
      t.timestamps
      t.boolean :described, default: false, null: false
      t.boolean :visible, default: true, null: false
      t.string :name, null: false, index: true
      t.string :summary
      t.text :description
    end
  end
end
