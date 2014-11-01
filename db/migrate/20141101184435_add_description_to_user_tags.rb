class AddDescriptionToUserTags < ActiveRecord::Migration
  def change
    add_column :user_tags, :description, :text
  end
end
