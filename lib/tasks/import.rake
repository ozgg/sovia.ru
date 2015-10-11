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

  desc 'Import users from YAML'
  task users: :environment do
    file_path = "#{Rails.root}/tmp/users.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          user = User.find_by id: id
          if user.is_a? User
            puts "User #{id} already exists"
          else
            user = User.new
            user.id = id
            user.network = data['network']
            user.created_at = data['created_at']
            user.uid = data['uid']
            user.email = data['email'] unless data['email'].blank?
            user.password_digest = data['password_digest']
            user.ip = data['ip'] unless data['ip'].blank?
            user.screen_name = data['screen_name'] unless data['screen_name'].blank?
            user.name = data['name'] unless data['name'].blank?
            user.bot = true if data['bot']
            user.email_confirmed = true if data['mail_confirmed']
            user.allow_mail = true if data['allow_mail']
            user.gender = data['gender'] unless data['gender'].nil?
            if File.exists? data['avatar'].to_s
              user.image = File.open data['avatar']
            elsif data['avatar_url_medium']
              user.remote_image_url = data['avatar_url_medium'].gsub('http://', 'https://')
            end
            user.save!
          end
          print "#{id}        \r"
        end
      end
      puts "Done. We have #{User.count} users"
    else
      puts "Cannot find file #{file_path}"
    end
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
