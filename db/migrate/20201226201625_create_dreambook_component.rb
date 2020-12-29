# frozen_string_literal: true

# Create tables for dreambook component
class CreateDreambookComponent < ActiveRecord::Migration[6.1]
  def up
    create_component
    create_patterns unless Pattern.table_exists?
    create_pattern_links unless PatternLink.table_exists?
  end

  def down
    [PatternLink, Pattern].each do |model|
      drop_table model.table_name if model.table_exists?
    end

    BiovisionComponent[Biovision::Components::DreambookComponent]&.destroy
  end

  private

  def create_component
    slug = Biovision::Components::DreambookComponent.slug
    BiovisionComponent.create(slug: slug)
  end

  def create_patterns
    create_table :patterns, comment: 'Dream patterns' do |t|
      t.uuid :uuid, null: false
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :simple_image, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.boolean :visible, default: true, null: false
      t.boolean :processed, index: true, default: false, null: false
      t.integer :dream_count, default: 0, null: false
      t.string :name, index: true, null: false
      t.string :summary
      t.text :description
      t.jsonb :data, default: {}, null: false
    end

    execute %(
      create or replace function patterns_tsvector(name text, summary text, description text)
        returns tsvector as $$
          begin
            return (
              setweight(to_tsvector('russian', name), 'A') ||
              setweight(to_tsvector('russian', coalesce(summary, '')), 'B') ||
              setweight(to_tsvector('russian', coalesce(description, '')), 'C')
            );
          end
        $$ language 'plpgsql' immutable;
    )
    execute "create index patterns_search_idx on patterns using gin(patterns_tsvector(name, summary, description));"

    add_index :patterns, :uuid, unique: true
    add_index :patterns, :data, using: :gin
  end

  def create_pattern_links
    create_table :pattern_links, comment: 'Links between patterns' do |t|
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :other_pattern_id, null: false
    end

    add_foreign_key :pattern_links, :patterns, column: :other_pattern_id, on_update: :cascade, on_delete: :cascade
  end
end
