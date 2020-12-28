# frozen_string_literal: true

# Create tables for posts component
class CreatePostsComponent < ActiveRecord::Migration[6.1]
  def up
    create_component
    create_posts unless Post.table_exists?
  end
  
  def down
    drop_table :posts if Post.table_exists?
    BiovisionComponent[Biovision::Components::PostsComponent]&.destroy
  end
  
  private
  
  def create_component
    slug = Biovision::Components::PostsComponent.slug
    BiovisionComponent.create(slug: slug)
  end
  
  def create_posts
    create_table :posts, comment: 'Posts' do |t|
      t.uuid :uuid, null: false
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :simple_image, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.datetime :publication_time
      t.boolean :visible, default: true, null: false
      t.boolean :featured, default: false, null: false
      t.string :title, null: false
      t.string :slug
      t.text :lead
      t.text :body, null: false
      t.string :source_name
      t.string :source_link
      t.jsonb :data, default: {}, null: false
    end

    execute "create index posts_pubdate_month_idx on posts using btree (date_trunc('month', publication_time));"
    execute %(
      create or replace function posts_tsvector(title text, lead text, body text)
        returns tsvector as $$
          begin
            return (
              setweight(to_tsvector('russian', title), 'A') ||
              setweight(to_tsvector('russian', coalesce(lead, '')), 'B') ||
              setweight(to_tsvector('russian', body), 'C')
            );
          end
        $$ language 'plpgsql' immutable;
    )
    execute "create index posts_search_idx on posts using gin(posts_tsvector(title, lead, body));"

    add_index :posts, :uuid, unique: true
    add_index :posts, :data, using: :gin
  end
end
