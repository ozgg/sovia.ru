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
        file.puts "  title: \"#{normalize_post_body(post.title)}\""
        file.puts "  lead: \"#{normalize_post_body(post.lead)}\"" unless post.lead.blank?
        file.puts '  show_in_list: true' if post.show_in_list?
        file.puts "  ip: \"#{post.ip}\"" unless post.ip.blank?
        file.puts "  created_at: \"#{post.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts "  body: \"#{normalize_post_body(post.body)}\""
      end
    end
  end

  desc "TODO: Export dreams to YAML"
  task dreams: :environment do
  end

  desc "TODO: Export questions to YAML"
  task questions: :environment do
  end

  desc "TODO: Export comments and answers to YAML"
  task comments: :environment do
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

  def normalize_post_body(string)
    string.gsub(/\r?\n/, '\n').gsub('"', '\"')
  end
end
