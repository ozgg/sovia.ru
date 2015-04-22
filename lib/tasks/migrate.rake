namespace :migrate do
  desc "Migrate dream tags into patterns"
  task patterns: :environment do
    language = Language.find_by_code 'ru'

    Tag::Dream.all.each do |tag|
      pattern = Pattern.match_or_create_by_name language, tag.name
      pattern.body = tag.description

      puts "Cannot migrate tag #{tag.name}" unless pattern.save
    end
  end

  desc "TODO"
  task dreams: :environment do
  end

end
