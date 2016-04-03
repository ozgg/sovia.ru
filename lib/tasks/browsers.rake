namespace :browsers do
  desc 'Import browsers from YAML'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/browsers.yml"
    if File.exists? file_path
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          browser = Browser.find_by id: id
          if browser.is_a? Browser
            print "\rBrowser #{id} already exists"
          else
            browser            = Browser.new id: id, name: data['name']
            browser.bot        = true if data['bot']
            browser.mobile     = true if data['mobile']
            browser.created_at = data['created_at'] if data.has_key? 'created_at'
            browser.save!
            print "\r#{id}"
          end
        end
        puts
      end
      Browser.connection.execute "select setval('browsers_id_seq', (select max(id) from browsers));"
      puts "Done. We have #{Browser.count} browsers now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export browsers to YAML'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/browsers.yml"
    File.open file_path, 'w' do |file|
      Browser.order('id asc').each do |browser|
        file.puts "#{browser.id}:"
        file.puts "  name: \"#{normalize_string(browser.name)}\""
        file.puts "  created_at: \"#{browser.created_at.strftime('%Y-%m-%d %H:%M:%S')}\""
        file.puts '  bot: true' if browser.bot?
        file.puts '  mobile: true' if browser.mobile?
      end
    end
  end

  # @param [String] string
  def normalize_string(string)
    string.gsub('\\', '\\\\').gsub(/\r?\n/, '\\n').gsub('"', '\\"')
  end
end
