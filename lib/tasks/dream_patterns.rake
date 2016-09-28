require 'fileutils'

namespace :dream_patterns do
  desc 'Load dream_patterns from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/dream_patterns.yml"
    image_dir = "#{Rails.root}/tmp/import/dream_patterns"
    if File.exists? file_path
      puts 'Deleting old dream_patterns...'
      DreamPattern.destroy_all
      puts 'Done. Importing...'
      ignored = %w(id)
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          attributes    = data.reject { |key| ignored.include? key }
          dream_pattern = DreamPattern.new id: id
          dream_pattern.assign_attributes attributes
          dream_pattern.save!
          print "\r#{id}    "
        end
        puts
      end
      DreamPattern.connection.execute "select setval('dream_patterns_id_seq', (select max(id) from dream_patterns));"
      puts "Done. We have #{DreamPattern.count} dream_patterns now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump dream_patterns to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/dream_patterns.yml"
    ignored   = %w(id)
    File.open file_path, 'w' do |file|
      DreamPattern.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
      end
      puts
    end
  end
end
