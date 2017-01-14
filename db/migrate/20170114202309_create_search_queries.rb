class CreateSearchQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :search_queries do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.string :body, null: false
    end
  end
end
