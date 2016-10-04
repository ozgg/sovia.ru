require 'fileutils'

namespace :questions do
  desc 'Load questions from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/questions.yml"
    if File.exists? file_path
      puts 'Deleting old questions...'
      Question.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          question = Question.new id: id
          question.assign_attributes data
          question.save!
          print "\r#{id}    "
        end
        puts
      end
      Question.connection.execute "select setval('questions_id_seq', (select max(id) from questions));"
      puts "Done. We have #{Question.count} questions now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump questions to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/questions.yml"
    ignored   = %w(id ip comments_count)
    File.open file_path, 'w' do |file|
      Question.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  ip: #{entity.ip}" unless entity.ip.blank?
      end
      puts
    end
  end
end
