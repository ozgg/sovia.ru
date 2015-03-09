namespace :convert do
  desc "Convert entries to posts"
  task posts: :environment do
    language = Language.find_by_code 'ru'
    puts "Converting Posts\n"
    Entry::Post.all.each do |entry|
      post = Post.new id: entry.id, created_at: entry.created_at, user: entry.user, language: language, title: entry.title, body: entry.body
      post.save!
    end

    puts "Converting Articles\n"
    Entry::Article.all.each do |entry|
      post = Post.new id: entry.id, created_at: entry.created_at, user: entry.user, language: language, title: entry.title, body: entry.body
      post.save!
    end
  end
end
