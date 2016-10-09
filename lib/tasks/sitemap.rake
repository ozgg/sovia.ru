namespace :sitemap do
  include Rails.application.routes.url_helpers
  default_url_options[:host]     = 'sovia.ru'
  default_url_options[:protocol] = 'https'

  desc "Generate sitemap files"
  task generate: :environment do
    header     = '<?xml version="1.0" encoding="UTF-8"?>'
    root_open  = '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
    root_close = '</urlset>'
    time_format = '%Y-%m-%dT%H:%M:%S%:z'

    File.open "#{Rails.root}/public/sitemap.posts.xml", 'w' do |f|
      f.puts header, root_open
      Post.visible.each do |entry|
        f.puts "<url>"
        f.puts "<loc>#{post_url(id: entry.id)}</loc>"
        f.puts "<lastmod>#{entry.updated_at.strftime(time_format)}</lastmod>"
        f.puts "</url>"
      end
      f.puts root_close
    end

    File.open "#{Rails.root}/public/sitemap.dreams.xml", 'w' do |f|
      f.puts header, root_open
      Dream.public_entries.each do |entry|
        f.puts "<url>"
        f.puts "<loc>#{dream_url(id: entry.id)}</loc>"
        f.puts "<lastmod>#{entry.updated_at.strftime(time_format)}</lastmod>"
        f.puts "</url>"
      end
      f.puts root_close
    end

    File.open "#{Rails.root}/public/sitemap.questions.xml", 'w' do |f|
      f.puts header, root_open
      Question.all.each do |entry|
        f.puts "<url>"
        f.puts "<loc>#{question_url(id: entry.id)}</loc>"
        f.puts "<lastmod>#{entry.updated_at.strftime(time_format)}</lastmod>"
        f.puts "</url>"
      end
      f.puts root_close
    end

    File.open "#{Rails.root}/public/sitemap.dreambook.xml", 'w' do |f|
      f.puts header, root_open
      Pattern.all.each do |entry|
        if entry.good_for_dreambook?
          f.puts "<url>"
          f.puts "<loc>#{dreambook_word_url(word: entry.name)}</loc>"
          f.puts "<lastmod>#{entry.updated_at.strftime(time_format)}</lastmod>"
          f.puts "</url>"
        end
      end
      f.puts root_close
    end
  end
end
