require 'fileutils'

namespace :dreams do
  desc 'Load dreams from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/dreams.yml"
    image_dir = "#{Rails.root}/tmp/import/dreams"
    if File.exists? file_path
      puts 'Deleting old dreams...'
      Dream.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        ignored = %w(image)
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include? key }
          dream      = Dream.new id: id
          dream.assign_attributes attributes
          if data.has_key? 'image'
            image_file  = "#{image_dir}/#{id}/#{data['image']}"
            dream.image = Pathname.new(image_file).open if File.exists?(image_file)
          end
          dream.save!
          print "\r#{id}    "
        end
        puts
      end
      Dream.connection.execute "select setval('dreams_id_seq', (select max(id) from dreams));"
      puts "Done. We have #{Dream.count} dreams now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump dreams to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/dreams.yml"
    image_dir = "#{Rails.root}/tmp/export/dreams"
    ignored   = %w(id image ip comments_count locked)
    Dir.mkdir image_dir unless Dir.exists? image_dir
    File.open file_path, 'w' do |file|
      Dream.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  ip: #{entity.ip}" unless entity.ip.blank?
        unless entity.image.blank?
          image_name = File.basename(entity.image.path)
          Dir.mkdir "#{image_dir}/#{entity.id}" unless Dir.exists? "#{image_dir}/#{entity.id}"
          FileUtils.copy entity.image.path, "#{image_dir}/#{entity.id}/#{image_name}"
          file.puts "  image: #{image_name.inspect}"
        end
      end
      puts
    end
  end

  desc 'Analyze dream words'
  task analyze: :environment do
    total = Dream.count
    Dream.where(patterns_set: false).each_with_index do |dream, index|
      string  = dream.body.gsub(Dream::LINK_PATTERN, '').gsub(Dream::NAME_PATTERN, '')
      handler = WordHandler.new(string, true)
      ids     = dream.pattern_ids

      print "\r#{index}/#{total}: #{dream.id}\t#{handler.word_ids.count} "

      dream.word_ids    = handler.word_ids
      dream.pattern_ids = (handler.pattern_ids | ids).uniq
    end
    puts
  end
end
