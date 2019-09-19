# frozen_string_literal: true

# Create tables for dreambook component
class CreateDreambook < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_patterns unless Pattern.table_exists?
  end

  def down
    drop_table :patterns if Pattern.table_exists?
  end

  private

  def create_component
    slug = Biovision::Components::DreambookComponent::SLUG

    return if BiovisionComponent.where(slug: slug).exists?

    BiovisionComponent.create!(slug: slug)
  end

  def create_patterns
    create_table :patterns, comment: 'Dreambook pattern' do |t|
      t.timestamps
      t.string :name, null: false
      t.string :summary
      t.text :description
    end

    add_index :patterns, :name, unique: true
  end
end
