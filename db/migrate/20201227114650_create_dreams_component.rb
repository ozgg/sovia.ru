# frozen_string_literal: true

# Create tables for dreams component
class CreateDreamsComponent < ActiveRecord::Migration[6.1]
  def up
    create_component
    create_sleep_places unless SleepPlace.table_exists?
    create_dreams unless Dream.table_exists?
    create_dream_patterns unless DreamPattern.table_exists?
    create_fillers unless Filler.table_exists?
    create_interpretations unless Interpretation.table_exists?
    create_interpretation_messages unless InterpretationMessage.table_exists?
  end

  def down
    [
      InterpretationMessage, Interpretation, Filler, DreamPattern, Dream,
      SleepPlace
    ].each do |model|
      drop_table model.table_name if model.table_exists?
    end

    BiovisionComponent[Biovision::Components::DreamsComponent]&.destroy
  end

  private

  def create_component
    slug = Biovision::Components::DreamsComponent.slug

    settings = {
      place_limit: 2,
      filler_timeout: 18,
      free_interpretations: 2
    }

    BiovisionComponent.create(slug: slug, settings: settings)
  end

  def create_sleep_places
    create_table :sleep_places, comment: 'Sleep places' do |t|
      t.uuid :uuid, null: false
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :dreams_count, default: 0, null: false
      t.string :name, null: false
    end

    add_index :sleep_places, :uuid, unique: true
  end

  def create_dreams
    create_table :dreams, comment: 'Dreams' do |t|
      t.uuid :uuid, null: false
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :simple_image, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :sleep_place, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.boolean :interpreted, default: false, null: false
      t.integer :lucidity, limit: 2, default: 0, null: false
      t.integer :privacy, limit: 2, default: 0, null: false
      t.string :title
      t.text :body, null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :dreams, :uuid, unique: true
    add_index :dreams, :privacy
    execute "create index dreams_created_month_idx on dreams using btree (date_trunc('month', created_at));"
    execute %(
      create or replace function dreams_tsvector(title text, body text)
        returns tsvector as $$
          begin
            return (
              setweight(to_tsvector('russian', coalesce(title, '')), 'A') ||
              setweight(to_tsvector('russian', body), 'B')
            );
          end
        $$ language 'plpgsql' immutable;
    )
    execute 'create index dreams_search_idx on dreams using gin(dreams_tsvector(title, body));'
  end

  def create_dream_patterns
    create_table :dream_patterns, comment: 'Links between dreams and patterns' do |t|
      t.references :dream, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end

  def create_fillers
    create_table :fillers, comment: 'Dream fillers' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.string :title
      t.text :body, null: false
    end
  end

  def create_interpretations
    create_table :interpretations, comment: 'Interpretation requests' do |t|
      t.uuid :uuid, null: false
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :dream, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.boolean :solved, default: false, null: false
      t.timestamps
      t.text :body
    end

    add_index :interpretations, :uuid, unique: true
  end

  def create_interpretation_messages
    create_table :interpretation_messages, comment: 'Messages in interpretation requests' do |t|
      t.uuid :uuid, null: false
      t.references :interpretation, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :from_user, default: false, null: false
      t.timestamps
      t.text :body, null: false
    end

    add_index :interpretation_messages, :uuid, unique: true
  end
end
