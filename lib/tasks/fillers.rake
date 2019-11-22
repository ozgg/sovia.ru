namespace :fillers do
  desc 'Apply filler'
  task apply: :environment do
    if (10..23).include?(Time.now.hour) && Dream.last.created_at < 5.hours.ago
      filler = Filler.first
      unless filler.nil?
        lag   = rand(3600).seconds.ago
        dream = Dream.new(title: filler.title, body: filler.body, created_at: lag)
        dream.user = filler.user
        if dream.save
          filler.destroy
        else
          puts "Cannot save dream from filler #{filler.id}: #{dream.errors}"
        end
      end
    end
  end
end