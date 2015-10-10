namespace :import do
  desc 'Import dream patterns from YAML'
  task patterns: :environment do
    file_path = "#{Rails.root}/tmp/patterns.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          pattern = Pattern.match_or_create_by_name data['name']
          pattern.update! description: data['description'] unless data['description'].blank?
          print " -> #{pattern.id}        \r"
        end
      end
      puts 'Done.'
    end
  end

  desc "TODO: Import users from YAML"
  task users: :environment do
  end

  desc "TODO: Import goals from YAML"
  task goals: :environment do
  end

  desc "TODO: Import deeds from YAML"
  task deeds: :environment do
  end

  desc "TODO: Import dreams from YAML"
  task dreams: :environment do
  end

  desc "TODO: Import questions from YAML"
  task questions: :environment do
  end

  desc "TODO: Import posts from YAML"
  task posts: :environment do
  end
end
