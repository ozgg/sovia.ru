# frozen_string_literal: true

# Create tables for dream interpretations
class CreateInterpretations < ActiveRecord::Migration[5.2]
  def up
    create_interpretations unless Interpretation.table_exists?
    create_interpretation_messages unless InterpretationMessage.table_exists?
  end

  def down
    drop_table :interpretation_messages if InterpretationMessage.table_exists?
    drop_table :interpretations if Interpretation.table_exists?
  end

  private

  def create_interpretations
    create_table :interpretations, comment: 'Interpretation requests' do |t|
      t.uuid :uuid, null: false
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :dream, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.boolean :solved, default: false, null: false
      t.timestamps
      t.text :body
    end

    add_index :interpretations, :uuid, unique: true
  end

  def create_interpretation_messages
    create_table :interpretation_messages, comment: 'Messages in interpretation requests' do |t|
      t.uuid :uuid, null: false
      t.references :interpretation, null: false, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.boolean :from_user, default: false, null: false
      t.timestamps
      t.text :body, null: false
    end

    add_index :interpretation_messages, :uuid, unique: true
  end
end
