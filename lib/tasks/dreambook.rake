namespace :dreambook do
  desc 'Amend breambook by removing doubles'
  task amend: :environment do
    merged = 0
    Pattern.order('id asc').each do |pattern|
      print "\r#{pattern.id}\t#{pattern.name}    "
      twin = Pattern.find_by('name ilike ? and id > ?', pattern.name, pattern.id)
      unless twin.nil?
        puts "->#{twin.id}\t#{twin.name}"
        pattern.essence     = "#{pattern.essence} #{twin.essence}".strip
        pattern.description = "#{pattern.description}\n#{twin.description}".strip
        pattern.save!
        %w(dream_patterns pattern_words).each do |table|
          query = "update #{table} set pattern_id = #{pattern.id} where pattern_id = #{twin.id}"
          Pattern.connection.execute(query)
        end

        Pattern.reset_counters(pattern.id, :dreams_count, :words_count)
        twin.destroy
        merged += 1
      end
    end
    puts
    puts "Merged: #{merged}"
  end
end
