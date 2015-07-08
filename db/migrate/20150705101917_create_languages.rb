class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code, null: false
      t.string :slug, null: false
    end
  end
end
