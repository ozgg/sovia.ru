class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :i18n_name, null: false
    end

    add_index :languages, :code, unique: true
  end
end
