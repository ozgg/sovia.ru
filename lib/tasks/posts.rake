require 'fileutils'

namespace :posts do
  desc 'Load posts from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/posts.yml"
    image_dir = "#{Rails.root}/tmp/import/posts"
    if File.exists? file_path
      puts 'Deleting old posts...'
      Post.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        ignored = %w(image tags_string)
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include? key }
          post       = Post.new id: id
          post.assign_attributes attributes
          if data.has_key? 'image'
            image_file = "#{image_dir}/#{id}/#{data['image']}"
            post.image = Pathname.new(image_file).open if File.exists?(image_file)
          end
          post.save!

          if data.has_key? 'tags_string'
            post.tags_string = data['tags_string']
            post.cache_tags!
          end
          print "\r#{id}    "
        end
        puts
      end
      Post.connection.execute "select setval('posts_id_seq', (select max(id) from posts));"
      puts "Done. We have #{Post.count} posts now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump posts to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/posts.yml"
    image_dir = "#{Rails.root}/tmp/export/posts"
    ignored   = %w(id image ip comments_count rating upvote_count downvote_count tags_cache)
    Dir.mkdir image_dir unless Dir.exists? image_dir
    File.open file_path, 'w' do |file|
      Post.order('id asc').each do |entity|
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
        if entity.tags.any?
          tags_string = entity.tags.map { |tag| tag.name }.join(', ')
          file.puts "  tags_string: #{tags_string.inspect}"
        end
      end
      puts
    end
  end
end
