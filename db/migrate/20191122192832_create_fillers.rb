# frozen_string_literal: true

# Create table for dream fillers
class CreateFillers < ActiveRecord::Migration[5.2]
  def change
    create_table :fillers, comment: 'Filler for dream' do |t|
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.string :title
      t.text :body, null: false
    end
  end
end
