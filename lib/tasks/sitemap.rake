namespace :sitemap do
  require "#{Rails.root}/app/helpers/application_helper"
  include ApplicationHelper
  include Rails.application.routes.url_helpers
  default_url_options[:host] = 'sovia.ru'

  desc "Generate sitemap for posts"
  task posts: :environment do
    sitemap = "#{Rails.root}/public/sitemap.posts.xml"
    File.open sitemap, 'w' do |f|
      f.puts '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
      Entry.public_entries.each do |entry|
        unless entry.is_a?(Entry::Article) || entry.is_a?(Entry::Post)
          f.puts "<url><loc>#{verbose_entry_url entry}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
        end
      end
      Post.all.each do |entry|
        f.puts "<url><loc>#{post_url(locale: entry.locale, id: entry.id)}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
      end
      f.puts "</urlset>\n"
    end
  end

  desc "Generate sitemap for dreambook"
  task dreambook: :environment do
    sitemap = "#{Rails.root}/public/sitemap.dreambook.xml"
    File.open sitemap, 'w' do |f|
      f.puts '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
      Tag::Dream.all.each do |entry|
        unless entry.description.blank?
          f.puts "<url><loc>#{dreambook_word_url letter: entry.letter, word: entry.name}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
        end
      end
      f.puts "</urlset>\n"
    end
  end

end
