namespace :import do
  desc 'Import user agents from YAML'
  task agents: :environment do
    file_path = "#{Rails.root}/tmp/agents.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          agent = Agent.find_by id: id
          if agent.is_a? Agent
            puts "Agent #{id} already exists"
          else
            agent = Agent.new
            agent.id = id
            agent.name = data['name'] unless data['name'].blank?
            agent.bot = true if data['bot']
            agent.save!
          end
          print "#{id}        \r"
        end
      end
      puts "Done. We have #{Agent.count} agents"
    else
      puts "Cannot find file #{file_path}"
    end
  end

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
            user.agent_id = data['agent_id'] unless data['agent_id'].blank?
            user.screen_name = data['screen_name'] || data['uid']
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
          deed = Deed.find_by id: id
          if deed.is_a? Deed
            puts "Deed #{id} exists"
          else
            print id
            deed = Deed.new
            deed.id = id
            deed.user_id = data['user_id']
            deed.goal_id = data['goal_id'] unless data['goal_id'].blank?
            deed.created_at = data['created_at']
            deed.essence = data['name']
            deed.save!
            print "    \r"
          end
        end
      end
      puts "Done. Now we have #{Deed.count} deeds."
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
          question = Question.find_by id: id
          if question.is_a? Question
            puts "Question #{id} already exists"
          else
            print id
            question = Question.new
            question.id = id
            question.user_id = data['user_id']
            question.body = data['body']
            question.created_at = data['created_at']
            question.ip = data['ip']
            question.agent_id = data['agent_id'] unless data['agent_id'].blank?
            question.save!
            print "    \r"
          end
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
          post = Post.find_by id: id
          if post.is_a? Post
            puts "Post #{id} already exists"
          else
            print id
            post = Post.new
            post.id = id
            post.user_id = data['user_id']
            post.ip = data['ip'] unless data['ip'].blank?
            post.agent_id = data['agent_id'] unless data['agent_id'].blank?
            post.show_in_list = data['show_in_list'] if data['show_in_list']
            post.created_at = data['created_at']
            post.title = data['title']
            post.lead = data['lead'] || data['title']
            if File.exists? data['image'].to_s
              post.image = File.open data['image']
            end
            post.body = data['body']
            post.save!
            print "    \r"
          end
        end
      end
      puts "Done. Now we have #{Post.count} posts."
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
          dream = Dream.find_by id: id
          if dream.is_a? Dream
            puts "Dream #{id} already exists"
          else
            print id
            dream = Dream.new
            dream.id = id
            dream.user_id = data['user_id'] unless data['user_id'].blank?
            dream.created_at = data['created_at']
            dream.lucidity = data['lucidity'] unless data['lucidity'].blank?
            dream.title = data['title'] unless data['title'].blank?
            dream.body = data['body']
            if data['privacy']
              dream.privacy = data['privacy'] == 1 ? :visible_to_community : :personal
            else
              dream.privacy = :generally_accessible
            end
            dream.save!
            if data['user_id'] && data['tags_string']
              dream.grains_string = data['tags_string']
              dream.cache_patterns!
            end
            print "    \r"
          end
        end
        puts "Done. Now we have #{Dream.count} dreams."
      end
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
          comment = Comment.find_by id: id
          if comment.is_a? Comment
            print "Comment #{id} already exists\r"
          else
            print id
            comment = Comment.new
            comment.id = id
            comment.user_id = data['user_id'] unless data['user_id'].blank?
            comment.ip = data['ip'] unless data['ip'].blank?
            comment.agent_id = data['agent_id'] unless data['agent_id'].blank?
            comment.parent_id = data['parent_id'] unless data['parent_id'].blank?
            comment.created_at = data['created_at']
            comment.body = data['body']
            comment.commentable_id = data['commentable_id']
            comment.commentable_type = (data['commentable_type'] == 'Entry') ? 'Dream' : data['commentable_type']
            begin
              comment.save!
            rescue ActiveRecord::RecordInvalid
              puts "! #{$!}"
            end
            print " \r"
          end
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
          question = Question.find_by id: data['question_id']
          if question.is_a? Question
            comment = Comment.new
            comment.commentable = question
            comment.user_id = data['user_id']
            comment.created_at = data['created_at']
            comment.ip = data['ip'] unless data['ip'].blank?
            comment.agent_id = data['agent_id'] unless data['agent_id'].blank?
            comment.body = data['body']
            comment.save!
          else
            puts ": cannot find question #{data['question_id']}"
          end
          print "    \r"
        end
      end
      puts "Done. Now we have #{Comment.count} comments."
    else
      puts "Cannot find file #{file_path}"
    end
  end
end
