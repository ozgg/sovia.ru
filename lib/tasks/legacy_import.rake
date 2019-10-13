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
  end

  desc 'Import dreams from legacy YAML'
  task dreams: :environment do
  end

  desc 'Import comments from legacy YAML'
  task comments: :environment do
  end
end
