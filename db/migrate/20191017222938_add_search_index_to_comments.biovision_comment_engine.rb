# frozen_string_literal: true
# This migration comes from biovision_comment_engine (originally 20191017202020)

# Add full-text search for comments
class AddSearchIndexToComments < ActiveRecord::Migration[5.2]
  def up
    execute %(
      create index if not exists
        comments_search_idx on comments 
        using gin(to_tsvector('russian', body));
    )
  end

  def down
    execute %(drop index if exists comments_search_idx)
  end
end
