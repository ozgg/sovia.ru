class CreateMetricValues < ActiveRecord::Migration[5.0]
  def change
    create_table :metric_values do |t|
      t.references :metric, foreign_key: true, null: false
      t.timestamp :time, null: false
      t.integer :quantity, null: false, default: 1
    end

    execute "create index metric_values_day_idx on metric_values using btree (date_trunc('day', time));"
  end
end
