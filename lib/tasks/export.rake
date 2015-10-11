namespace :export do
  desc 'Export dream patterns to YAML'
  task patterns: :environment do
    File.open("#{Rails.root}/tmp/patterns.yml", 'w') do |file|
      Tag::Dream.order('id asc').each do |pattern|
        description = replace_old_pattern_links(pattern.description.to_s).gsub('"', '\"').gsub(/\r?\n/, '\n')
        file.puts "#{pattern.id}:"
        file.puts "  name: \"#{pattern.name}\""
        file.puts "  description: \"#{description.strip}\""
      end
    end
  end

  desc 'Export users to YAML'
  task users: :environment do
    File.open("#{Rails.root}/tmp/users.yml", 'w') do |file|
      User.order('id asc').each do |user|
        file.puts "#{user.id}:"
        file.puts "  network: \"#{user.network}\""
        file.puts "  uid: \"#{user.login}\""
        file.puts "  email: \"#{user.email}\"" unless user.email.blank?
        file.puts "  password_digest: \"#{user.password_digest}\""
        file.puts "  avatar: \"#{Rails.root}/public#{user.avatar.url}\"" unless user.avatar.blank?
        file.puts "  mail_confirmed: #{user.mail_confirmed}" if user.mail_confirmed?
        file.puts "  allow_mail: #{user.allow_mail}" if user.allow_mail?
        file.puts "  created_at: \"#{user.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  gender: #{user.gender}" unless user.gender.blank?
        file.puts "  ip: \"#{user.ip}\"" unless user.ip.blank?
        file.puts "  bot: #{user.bot}" if user.bot?
        file.puts "  name: \"#{user.name}\"" unless user.name.blank?
        file.puts "  screen_name: \"#{user.screen_name}\"" unless user.screen_name.blank?
        file.puts "  avatar_url_small: \"#{user.avatar_url_small}\"" unless user.avatar_url_small.blank?
        file.puts "  avatar_url_medium: \"#{user.avatar_url_medium}\"" unless user.avatar_url_medium.blank?
        file.puts "  avatar_url_big: \"#{user.avatar_url_big}\"" unless user.avatar_url_big.blank?
      end
    end
  end

  desc 'Export goals to YAML'
  task goals: :environment do
    File.open("#{Rails.root}/tmp/goals.yml", 'w') do |file|
      Goal.order('id asc').each do |goal|
        file.puts "#{goal.id}:"
        file.puts "  user_id: #{goal.user_id}"
        file.puts "  status: \"#{goal.status}\""
        file.puts "  name: \"#{goal.name}\""
        file.puts "  description: \"#{goal.description}\""
        file.puts "  created_at: \"#{goal.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  updated_at: \"#{goal.updated_at.strftime('%Y-%m-%d %H:%M:%S')}\""
      end
    end
  end

  desc 'Export deeds to YAML'
  task deeds: :environment do
    File.open("#{Rails.root}/tmp/deeds.yml", 'w') do |file|
      Deed.order('id asc').each do |deed|
        file.puts "#{deed.id}:"
        file.puts "  user_id: #{deed.user_id}"
        file.puts "  goal_id: #{deed.goal_id}" unless deed.goal_id.blank?
        file.puts "  name: \"#{deed.name}\""
        file.puts "  created_at: \"#{deed.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
      end
    end
  end

  desc 'Export posts to YAML'
  task posts: :environment do
    File.open("#{Rails.root}/tmp/posts.yml", 'w') do |file|
      Post.order('id asc').each do |post|
        file.puts "#{post.id}:"
        file.puts "  user_id: #{post.user_id}"
        file.puts "  image: \"#{Rails.root}/public#{post.image.url}\"" unless post.image.blank?
        file.puts "  title: \"#{normalize_string(post.title)}\""
        file.puts "  lead: \"#{normalize_string(post.lead)}\"" unless post.lead.blank?
        file.puts '  show_in_list: true' if post.show_in_list?
        file.puts "  ip: \"#{post.ip}\"" unless post.ip.blank?
        file.puts "  created_at: \"#{post.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  body: \"#{normalize_string(post.body)}\""
      end
    end
  end

  desc 'Export dreams to YAML'
  task dreams: :environment do
    File.open("#{Rails.root}/tmp/dreams.yml", 'w') do |file|
      Entry::Dream.order('id asc').each do |dream|
        file.puts "#{dream.id}:"
        file.puts "  user_id: #{dream.user_id}" unless dream.user_id.blank?
        file.puts "  privacy: #{dream.privacy}" if dream.privacy > 0
        file.puts "  title: \"#{normalize_string(dream.title)}\"" unless dream.title.blank?
        file.puts "  lucidity: #{dream.lucidity}" if dream.lucidity > 0
        file.puts "  created_at: \"#{dream.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  tags_string: \"#{dream.tags_string}\""
        file.puts "  body: \"#{parse_dream_body(dream.body)}\""
      end
    end
  end

  desc 'Export questions to YAML'
  task questions: :environment do
    File.open("#{Rails.root}/tmp/questions.yml", 'w') do |file|
      Question.order('id asc').each do |question|
        file.puts "#{question.id}:"
        file.puts "  user_id: #{question.user_id}"
        file.puts "  created_at: \"#{question.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  body: \"#{normalize_string(question.body)}\""
        file.puts "  ip: \"#{question.ip}\"" unless question.ip.blank?
      end
    end
  end

  desc 'Export comments to YAML'
  task comments: :environment do
    File.open("#{Rails.root}/tmp/comments.yml", 'w') do |file|
      Comment.order('id asc').each do |comment|
        file.puts "#{comment.id}:"
        file.puts "  parent_id: #{comment.parent_id}" unless comment.parent_id.blank?
        file.puts "  user_id: #{comment.user_id}" unless comment.user_id.blank?
        file.puts '  is_visible: false' unless comment.is_visible?
        file.puts "  ip: \"#{comment.ip}\"" unless comment.ip.blank?
        file.puts "  created_at: \"#{comment.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  commentable_id: #{comment.commentable_id}"
        file.puts "  commentable_type: \"#{comment.commentable_type}\""
        file.puts "  body: \"#{parse_comment_body(comment.body)}\""
      end
    end
  end

  desc 'Export answers to YAML'
  task answers: :environment do
  end

  # Replace old dreambook pattern links with new format
  #
  # Replaces <symbol name="Pattern" text="text" /> with [[Pattern]](text)
  #
  # @param [String] string
  def replace_old_pattern_links(string)
    pattern = /[<\[]symbol\s+name="(?<name>[^"]+)"\s*(?:text="(?<text>[^"]+)"\s*)?\/?[>\]]/
    string.gsub('<p>', '').gsub('</p>', "\n").gsub pattern do |chunk|
      match = pattern.match chunk
      "[[#{match[:name]}]]" + (match[:text] ? "(#{match[:text]})" : '')
    end
  end

  def normalize_string(string)
    string.gsub(/\r?\n/, '\n').gsub('"', '\"')
  end

  def parse_dream_body(string)
    string_with_dreams = old_dream_links string
    string_with_patterns = replace_old_pattern_links string_with_dreams
    string_with_patterns.gsub(/\r?\n/, '\n').gsub('"', '\"')
  end

  def parse_comment_body(string)
    string_with_dreams = old_dream_links string
    string_with_dreams.gsub(/\r?\n/, '\n').gsub('"', '\"')
  end

  def old_dream_links(string)
    '<dream id="2000" title="трижды переплыла через реку" />'
    pattern = /[<\[]dream\s+id="(?<id>\d+)"\s*(?:title="(?<text>[^"]+)"\s*)?\s*\/?[>\]]/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      "[dream #{match[:id]}]" + (match[:text] ? "(#{match[:text]})" : '')
    end
  end
end
