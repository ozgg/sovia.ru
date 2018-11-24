# This migration comes from biovision_base_engine (originally 20180722222222)
class AddActiveToLanguages < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:languages, :active)
      add_column :languages, :active, :boolean
    end
  end

  def down
    # No rollback needed
  end
end
