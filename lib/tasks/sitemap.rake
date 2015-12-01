namespace :sitemap do
  include Rails.application.routes.url_helpers
  default_url_options[:host] = 'sovia.ru'
  default_url_options[:protocol] = 'https'

  desc "Generate sitemap files"
  task generate: :environment do
    File.open "#{Rails.root}/public/sitemap.posts.xml", 'w' do |f|
      f.puts '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
      Post.all.each do |entry|
        f.puts "<url><loc>#{post_url(id: entry.id)}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
      end
      f.puts "</urlset>\n"
    end

    File.open "#{Rails.root}/public/sitemap.dreams.xml", 'w' do |f|
      f.puts '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
      Dream.public_entries.each do |entry|
        f.puts "<url><loc>#{dream_url(id: entry.id)}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
      end
      f.puts "</urlset>\n"
    end

    File.open "#{Rails.root}/public/sitemap.questions.xml", 'w' do |f|
      f.puts '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
      Question.all.each do |entry|
        f.puts "<url><loc>#{question_url(id: entry.id)}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
      end
      f.puts "</urlset>\n"
    end

    File.open "#{Rails.root}/public/sitemap.dreambook.xml", 'w' do |f|
      f.puts '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
      Pattern.all.each do |entry|
        if entry.good_for_dreambook?
          f.puts "<url><loc>#{dreambook_word_url(letter: entry.letter, word: entry.name)}</loc><lastmod>#{entry.updated_at.w3c}</lastmod></url>"
        end
      end
      f.puts "</urlset>\n"
    end
  end
end
