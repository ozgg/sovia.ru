class CreateMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :metrics do |t|
      t.string :name, null: false
      t.string :description
    end
  end
end
