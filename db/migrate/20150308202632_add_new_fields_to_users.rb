class AddNewFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :posts_count, :integer, null: false, default: 0
    add_column :users, :dreams_count, :integer, null: false, default: 0
    add_reference :users, :language, index: true

    language = Language.find_by(code: 'ru')
    if language.is_a? Language
      User.update_all language_id: language.id
    end
  end
end
