require 'fileutils'

namespace :places do
  desc 'Load places from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/places.yml"
    image_dir = "#{Rails.root}/tmp/import/places"
    if File.exists? file_path
      puts 'Deleting old places...'
      Place.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        ignored = %w(image)
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include? key }
          place       = Place.new id: id
          place.assign_attributes attributes
          if data.has_key? 'image'
            image_file = "#{image_dir}/#{id}/#{data['image']}"
            place.image = Pathname.new(image_file).open if File.exists?(image_file)
          end
          place.save!
          print "\r#{id}    "
        end
        puts
      end
      Place.connection.execute "select setval('places_id_seq', (select max(id) from places));"
      puts "Done. We have #{Place.count} places now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump places to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/places.yml"
    image_dir = "#{Rails.root}/tmp/export/places"
    ignored   = %w(id image)
    Dir.mkdir image_dir unless Dir.exists? image_dir
    File.open file_path, 'w' do |file|
      Place.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
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
end
