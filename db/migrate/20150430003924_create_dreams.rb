class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.references :user, index: true
      t.references :language, index:true, null: false
      t.references :agent, index: true
      t.inet :ip
      t.integer :privacy, null: false, default: 0
      t.integer :lucidity, null: false, default: 0
      t.integer :factors, null: false, default: 0
      t.boolean :needs_interpretation, null: false, default: false
      t.integer :time_of_day
      t.integer :comments_count, null: false, default: 0
      t.string :image
      t.string :title
      t.text :body, null: false

      t.timestamps
    end
  end
end
