# frozen_string_literal: true

namespace :legacy_import do
  desc 'Import users from legacy YAML'
  task users: :environment do
    file_path = "#{Rails.root}/tmp/import/users.yml"
    media_dir = "#{Rails.root}/tmp/import/users"
    if File.exist? file_path
      puts 'Importing legacy users...'
      importer = LegacyImporter.new(media_dir)
      File.open(file_path, 'r') do |file|
        YAML.safe_load(file).each do |id, data|
          print "\r#{id}   "
          importer.import_user(id, data)
        end
        puts
      end
      User.connection.execute "select setval('users_id_seq', (select max(id) from users));"
      puts "Done. We have #{User.count} users now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import places from legacy YAML'
  task places: :environment do
    file_path = "#{Rails.root}/tmp/import/places.yml"
    if File.exist? file_path
      puts 'Importing legacy sleep places...'
      File.open(file_path, 'r') do |file|
        YAML.safe_load(file).each do |id, data|
          print "\r#{id}   "
          entity = SleepPlace.find_or_initialize_by(id: id)
          entity.user_id = data['user_id']
          entity.name = data['name']
          entity.save!
        end
        puts
      end
      SleepPlace.connection.execute "select setval('sleep_places_id_seq', (select max(id) from sleep_places));"
      puts "Done. We have #{SleepPlace.count} sleep places now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import posts from legacy YAML'
  task posts: :environment do
    file_path = "#{Rails.root}/tmp/import/posts.yml"
    media_dir = "#{Rails.root}/tmp/import/posts"
    if File.exist? file_path
      puts 'Importing legacy posts...'
      importer = LegacyImporter.new(media_dir)
      File.open(file_path, 'r') do |file|
        YAML.safe_load(file).each do |id, data|
          print "\r#{id}   "
          importer.import_post(id, data)
        end
        puts
      end
      Post.connection.execute "select setval('posts_id_seq', (select max(id) from posts));"
      puts "Done. We have #{Post.count} posts now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import dreams from legacy YAML'
  task dreams: :environment do
    file_path = "#{Rails.root}/tmp/import/dreams.yml"
    if File.exist? file_path
      puts 'Importing legacy dreams...'
      importer = LegacyImporter.new
      File.open(file_path, 'r') do |file|
        YAML.safe_load(file).each do |id, data|
          print "\r#{id}   "
          importer.import_dream(id, data)
        end
        puts
      end
      Dream.connection.execute "select setval('dreams_id_seq', (select max(id) from dreams));"
      puts "Done. We have #{Dream.count} dreams now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import comments from legacy YAML'
  task comments: :environment do
    file_path = "#{Rails.root}/tmp/import/comments.yml"
    ignored   = %w[agent]
    if File.exist?(file_path)
      puts 'Importing legacy comments...'
      File.open(file_path, 'r') do |file|
        YAML.safe_load(file).each do |id, data|
          print "\r#{id}    "
          next if data['commentable_type'] == 'Question'

          entity     = Comment.find_or_initialize_by(id: id)
          attributes = data.reject { |key| ignored.include? key }
          entity.assign_attributes(attributes)
          entity.agent = Agent[data['agent']] if data.key?('agent')
          entity.save(validate: false)
        end
        puts
      end
      Comment.connection.execute "select setval('comments_id_seq', (select max(id) from comments));"
      puts "Done. We have #{Comment.count} comments now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import tokens from legacy YAML'
  task tokens: :environment do
    file_path = "#{Rails.root}/tmp/import/tokens.yml"
    ignored = %w[agent]
    if File.exist? file_path
      puts 'Importing legacy tokens...'
      File.open(file_path, 'r') do |file|
        YAML.safe_load(file).each do |id, data|
          print "\r#{id}   "
          attributes = data.reject { |key| ignored.include? key }
          entity = Token.find_or_initialize_by(id: id)
          entity.assign_attributes(attributes)
          entity.agent = Agent[data['agent']] if data.key?('agent')
          entity.save!
        end
        puts
      end
      Token.connection.execute "select setval('tokens_id_seq', (select max(id) from tokens));"
      puts "Done. We have #{Token.count} tokens now"
    else
      puts "Cannot find file #{file_path}"
    end
  end
end
