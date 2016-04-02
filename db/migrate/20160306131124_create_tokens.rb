class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.inet :ip
      t.boolean :active, null: false, default: true
      t.string :token, null: false
    end

    add_index :tokens, :token, unique: true
  end
end
