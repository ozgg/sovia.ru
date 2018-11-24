# This migration comes from biovision_base_engine (originally 20180612111111)
class AddAdministrativeToPrivilege < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:privileges, :administrative)
      add_column :privileges, :administrative, :boolean, default: true, null: false
    end
  end

  def down
    # No need to rollback
  end
end
