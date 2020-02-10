# frozen_string_literal: true

# Add "interpretation given" flag to dreams
class AddInterpretedToDreams < ActiveRecord::Migration[5.2]
  def change
    add_column :dreams, :interpreted, :boolean, default: false, null: false
  end
end
