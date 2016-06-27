namespace :agents do
  desc 'Import agents from YAML with deleting old data'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/agents.yml"
    if File.exists? file_path
      puts 'Deleting old agents...'
      Agent.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          agent = Agent.new id: id
          agent.assign_attributes data
          agent.save!
          print "\r#{id}"
        end
        puts
      end
      Agent.connection.execute "select setval('agents_id_seq', (select max(id) from agents));"
      puts "Done. We have #{Agent.count} agents now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export agents to YAML'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/agents.yml"
    File.open file_path, 'w' do |file|
      Agent.order('id asc').each do |agent|
        file.puts "#{agent.id}:"
        agent.attributes.except(:id).each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
      end
    end
  end
end
