# frozen_string_literal: true

namespace :dreambook do
  desc 'Import patterns from legacy YAML file'
  task import_legacy_patterns: :environment do
    file_path = "#{Rails.root}/tmp/import/dreambook_entries.yml"
    if File.exist? file_path
      puts 'Importing legacy patterns...'
      File.open file_path, 'r' do |file|
        YAML.safe_load(file).each do |id, data|
          next if data['description'].blank? && data['essence'].blank?

          name = data['name']
          pattern = Pattern.find_or_initialize_by(name: name)

          attributes = {
            created_at: data['created_at'],
            description: data['description'],
            summary: data['summary'],
            updated_at: data['updated_at']
          }

          pattern.assign_attributes attributes
          pattern.save!
          print "\r#{id}: #{name}    "
        end
        puts
      end
      puts "Done. We have #{Pattern.count} patterns now"
    else
      puts "Cannot find file #{file_path}"
    end
  end
end
