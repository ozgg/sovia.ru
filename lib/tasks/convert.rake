namespace :convert do
  desc "Convert entries to posts"
  task posts: :environment do
    language = Language.find_by_code 'ru'
    puts "Converting Posts\n"
    Entry::Post.all.each do |entry|
      post = Post.find_by(id: entry.id) || Post.new
      post.set_from_entry entry
      post.language = language
      post.save!
    end

    puts "Converting Articles\n"
    Entry::Article.all.each do |entry|
      post = Post.find_by(id: entry.id) || Post.new
      post.set_from_entry entry
      post.language = language
      post.save!
    end
  end
end
