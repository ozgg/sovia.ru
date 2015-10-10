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
          print "\t#{pattern.id}        \r"
        end
      end
      puts "Done. Now we have #{Pattern.count} patterns."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import pattern names'
  task pattern_names: :environment do
    file_path = "#{Rails.root}/tmp/patterns.txt"
    if File.exists? file_path
      File.open(file_path).read.each_line do |name|
        unless name.blank?
          pattern = Pattern.match_or_create_by_name name
          print "#{pattern.id}\t#{pattern.name}    \r"
        end
      end
      puts "Done. Now we have #{Pattern.count} patterns."
    else
      puts "Cannot find file #{file_path}"
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
