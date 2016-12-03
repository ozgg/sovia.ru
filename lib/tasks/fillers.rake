namespace :fillers do
  desc "Apply filler"
  task apply: :environment do
    if Dream.last.created_at < 5.hours.ago
      filler = Filler.first
      unless filler.nil?
        lag   = rand(3600).seconds.ago
        dream = Dream.new(title: filler.title, body: filler.body, created_at: lag)
        if filler.user.nil?
          if filler.gender.nil?
            selection = User.bots(1)
          else
            selection = User.bots(1).where(gender: filler.gender)
          end
          dream.user = selection.offset(rand(selection.count)).first
        else
          dream.user = filler.user
        end
        if dream.save
          filler.destroy
          AnalyzeDreamJob.perform_later(dream.id)
        else
          puts "Cannot save dream from filler #{filler.id}: #{dream.errors}"
        end
      end
    end
  end
end
