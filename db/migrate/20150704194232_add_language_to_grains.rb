class AddLanguageToGrains < ActiveRecord::Migration
  def change
    add_reference :grains, :language, index: true
  end
end
