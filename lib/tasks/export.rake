namespace :export do
  desc 'Export dream patterns to YAML'
  task patterns: :environment do
    File.open("#{Rails.root}/tmp/patterns.yml", 'w') do |file|
      Tag::Dream.order('id asc').each do |pattern|
        file.puts "#{pattern.id}:"
        file.puts "  name: \"#{pattern.name}\""
        file.puts "  description: \"#{replace_old_pattern_links(pattern.description.to_s).squish}\""
      end
    end
  end

  desc "TODO: Export users to YAML"
  task users: :environment do
  end

  desc "TODO: Export dreams to YAML"
  task dreams: :environment do
  end

  desc "TODO: Export posts to YAML"
  task posts: :environment do
  end

  desc "TODO: Export questions to YAML"
  task questions: :environment do
  end

  desc "TODO: Export comments and answers to YAML"
  task comments: :environment do
  end

  desc "TODO: Export goals to YAML"
  task goals: :environment do
  end

  desc "TODO: Export deeds to YAML"
  task deeds: :environment do
  end

  # Replace old dreambook pattern links with new format
  #
  # Replaces <symbol name="Pattern" text="text" /> with [[Pattern]](text)
  #
  # @param [String] string
  def replace_old_pattern_links(string)
    pattern = /[<\[]symbol\s+name="(?<name>[^"]+)"\s*\/?[>\]]/
    string.gsub('<p>', '').gsub('</p>', "\n").gsub pattern do |chunk|
      match = pattern.match chunk
      "[[#{match[:name]}]]"
    end
  end
end
