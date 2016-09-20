class CreateFigures < ActiveRecord::Migration[5.0]
  def change
    create_table :figures do |t|
      t.references :post, foreign_key: true
      t.string :slug, null: false
      t.string :image
      t.string :caption
      t.string :alt_text
    end
  end
end
