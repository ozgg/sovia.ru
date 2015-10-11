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

  desc 'Import goals from YAML'
  task goals: :environment do
    file_path = "#{Rails.root}/tmp/goals.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          goal = Goal.find_by id: id
          if goal.is_a? Goal
            puts "Goal #{id} already exists"
          else
            print id
            goal = Goal.new
            goal.id = id
            goal.user_id = data['user_id']
            goal.status  = data['status']
            goal.name    = data['name']
            goal.created_at = data['created_at']
            goal.updated_at = data['updated_at']
            goal.description = data['description']
            goal.save!
            print "    \r"
          end
        end
      end
      puts "Done. Now we have #{Goal.count} goals."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import deeds from YAML'
  task deeds: :environment do
    file_path = "#{Rails.root}/tmp/deeds.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          print "    \r"
        end
      end
      puts "Done. Now we have #{Deed.count} deeds."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import dreams from YAML'
  task dreams: :environment do
    file_path = "#{Rails.root}/tmp/dreams.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          print "    \r"
        end
      end
      puts "Done. Now we have #{Dream.count} dreams."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import questions from YAML'
  task questions: :environment do
    file_path = "#{Rails.root}/tmp/questions.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          print "    \r"
        end
      end
      puts "Done. Now we have #{Question.count} questions."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import posts from YAML'
  task posts: :environment do
    file_path = "#{Rails.root}/tmp/posts.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          print "    \r"
        end
      end
      puts "Done. Now we have #{Post.count} posts."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import comments from YAML'
  task comments: :environment do
    file_path = "#{Rails.root}/tmp/comments.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          print "    \r"
        end
      end
      puts "Done. Now we have #{Comment.count} comments."
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Import answers from YAML'
  task answers: :environment do
    file_path = "#{Rails.root}/tmp/answers.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print id
          print "    \r"
        end
      end
      puts "Done. Now we have #{Comment.count} comments."
    else
      puts "Cannot find file #{file_path}"
    end
  end
end