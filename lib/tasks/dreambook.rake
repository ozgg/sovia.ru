namespace :dreambook do
  desc 'Import patterns from YAML'
  task import: :environment do
  end

  desc 'Dump patterns to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/patterns.yml"
    ignored   = %w[id]
    File.open file_path, 'w' do |file|
      Pattern.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |a, v|
          file.puts "  #{a}: #{v.inspect}"
        end
      end
      puts
    end
  end

  desc 'Import entries from legacy dreambook records in YAML'
  task legacy_import: :environment do
    file_path = "#{Rails.root}/tmp/import/dreambook_entries.yml"
    if File.exist? file_path
      puts 'Importing legacy dreambook patterns...'
      ignored = %w[id image dream_count upvote_count downvote_count locked deleted slug rating essence]
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          print "\r#{id}    "

          next if data['description'].blank?

          attributes = data.reject { |key| ignored.include? key }
          entity     = DreambookEntry.find_by(id: id) || DreambookEntry.new(id: id)
          entity.assign_attributes(attributes)
          entity.summary = data['essence']
          entity.save!

          next if data['essence'].blank?

          entity = Pattern.find_by(name: data['name']) || Pattern.new(name: data['name'])

          entity.summary = data['essence']
          entity.save!
        end
        puts
      end
      DreambookEntry.connection.execute "select setval('dreambook_entries_id_seq', (select max(id) from dreambook_entries));"
      puts "Done. We have #{DreambookEntry.count} legacy patterns and #{Pattern.count} patterns now"
    else
      puts "Cannot find file #{file_path}"
    end
  end
end
