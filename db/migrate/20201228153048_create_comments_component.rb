# frozen_string_literal: true

# Create tables for comments component
class CreateCommentsComponent < ActiveRecord::Migration[6.1]
  def up
    create_component
    create_comments unless Comment.table_exists?
  end
  
  def down
    drop_table :comments if Comment.table_exists?
    BiovisionComponent[Biovision::Components::CommentsComponent]&.destroy
  end
  
  private
  
  def create_component
    slug = Biovision::Components::CommentsComponent.slug
    BiovisionComponent.create(slug: slug)
  end
  
  def create_comments
    create_table :comments, comment: 'Comments' do |t|
      t.uuid :uuid, null: false
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.integer :commentable_id, null: false
      t.string :commentable_type, null: false
      t.integer :parent_id
      t.timestamps
      t.boolean :visible, default: true, null: false
      t.text :body
      t.jsonb :data, default: {}, null: false
      t.string :parents_cache, default: '', null: false
      t.integer :children_cache, default: [], array: true, null: false
    end

    add_index :comments, %i[commentable_id commentable_type]
    add_index :comments, :uuid, unique: true
    add_index :comments, :data, using: :gin
    add_foreign_key :comments, :comments, column: :parent_id, on_update: :cascade, on_delete: :cascade

    execute %(
      create index if not exists
        comments_search_idx on comments
        using gin(to_tsvector('russian', body));
    )
  end
end
