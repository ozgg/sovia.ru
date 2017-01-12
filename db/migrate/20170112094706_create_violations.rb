class CreateViolations < ActiveRecord::Migration[5.0]
  def change
    create_table :violations do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.string :tag
      t.string :title
      t.text :body, null: false
    end
  end
end
