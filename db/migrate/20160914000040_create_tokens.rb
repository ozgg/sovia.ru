class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.timestamps
      t.datetime :last_used, index: true
      t.references :user, foreign_key: true, null: false
      t.references :agent, foreign_key: true
      t.inet :ip
      t.boolean :active, null: false, default: true
      t.string :token, null: false
    end

    add_index :tokens, :token, unique: true
  end
end
