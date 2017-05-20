# This migration comes from biovision_base_engine (originally 20170301000101)
class CreateBrowsers < ActiveRecord::Migration[5.0]
  def change
    change_table :browsers do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
