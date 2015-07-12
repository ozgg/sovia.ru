class CreateUserLanguages < ActiveRecord::Migration
  def change
    create_table :user_languages do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :language, index: true, foreign_key: true, null: false
    end
  end
end
