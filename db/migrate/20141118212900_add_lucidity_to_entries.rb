class AddLucidityToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :lucidity, :integer, default: 0

    Entry.where(lucid: true).each do |entry|
      entry.lucidity = 1
      entry.save!
    end

    remove_column :entries, :lucid
  end
end
